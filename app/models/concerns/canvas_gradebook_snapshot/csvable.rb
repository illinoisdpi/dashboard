module CanvasGradebookSnapshot::Csvable
  extend ActiveSupport::Concern

  class InvalidCanvasShortnameError < StandardError; end
  class MissingCsvFileError < StandardError; end

  included do
    attr_accessor :csv_file

    validates :csv_file, presence: true
    validates :csv_filename, uniqueness: true, format: { with: ->(canvas_gradebook_snapshot) { /\A.*#{Regexp.escape(canvas_gradebook_snapshot.cohort.canvas_shortname)}.*\z/ }, message: "must contain canvas shortname belonging to this cohort" }

    before_validation :process_csv_filename
    after_create :process_csv
  end

  class_methods do
    def extract_assignment_name(assignment_name_raw)
      name_array = assignment_name_raw.to_s.split("_")

      name_array.take(name_array.length - 1).join(" ")
    end

    def extract_id_from_canvas(assignment_name_raw)
      assignment_name_raw.to_s.split("_").pop.gsub(/\D/, "")
    end

    def extract_downloaded_at(csv_filename)
      DateTime.strptime(csv_filename.split("_").at(0), "%Y-%m-%dT%H%M")
    end
  end

  def to_csv
    canvas_submissions_by_enrollment = self.canvas_submissions.group_by(&:enrollment_id)

    CSV.generate do |csv|
      canvas_assignments = self.canvas_assignments.unscope(:order).order(:position).to_a

      headers = ["User", "Role"] + canvas_assignments.map(&:name)
      csv << headers

      points_possible_row = ["Points Possible", ""] + canvas_assignments.map(&:points_possible)
      csv << points_possible_row

      self.enrollments.each do |enrollment|
        canvas_submissions = canvas_submissions_by_enrollment[enrollment.id].index_by(&:canvas_assignment_id)

        row = [
          enrollment.user.to_s,
          enrollment.role.to_s,
        ]

        canvas_assignments.each do |canvas_assignment|
          points = canvas_submissions[canvas_assignment.id]&.points || ""
          row << points
        end

        csv << row
      end
    end
  end

  private

  def process_csv_filename
    raise MissingCsvFileError.new("Please select a CSV file") if self.csv_file.blank?
    self.csv_filename = csv_file.original_filename
    self.downloaded_at = CanvasGradebookSnapshot.extract_downloaded_at(csv_filename)
    validate_canvas_shortname
  rescue InvalidCanvasShortnameError => e
    errors.add(:csv_filename, e.message)
  rescue MissingCsvFileError => e
    errors.add(:csv_file, e.message)
  rescue Date::Error
    errors.add(:csv_filename, "Invalid format for downloaded_at in CSV filename. Expected format: 'YYYY-MM-DDTHHMM'")
  end

  def validate_canvas_shortname
    raise InvalidCanvasShortnameError.new("Please add canvas shortname to selected cohort") if cohort.canvas_shortname.blank?
    canvas_shortname_regex = Regexp.new(Regexp.escape(cohort.canvas_shortname))
    unless canvas_shortname_regex.match?(csv_filename)
      raise InvalidCanvasShortnameError.new("Invalid canvas shortname in CSV filename. Expected format: '#{cohort.canvas_shortname}'")
    end
  end

  def process_csv
    ActiveRecord::Base.transaction do
      begin
        csv = SmarterCSV.process(csv_file)

        existing_assignments = cohort.canvas_assignments.index_by(&:id_from_canvas)
        existing_users = User.where(email: csv.map { |row| row[:sis_login_id] }.compact.uniq).index_by(&:email)
        existing_enrollments = cohort.enrollments.index_by(&:user_id)

        header_row = csv.first
        assignment_headers = header_row.to_a.each_with_object([]) do |(assignment_name_raw, points_possible), assignments|
          next unless points_possible.is_a?(Numeric)

          id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
          name = CanvasGradebookSnapshot.extract_assignment_name(assignment_name_raw)

          assignments << { id_from_canvas: id_from_canvas, name: name, points_possible: points_possible }
          unless existing_assignments.key?(id_from_canvas)
            begin
              new_assignment = cohort.canvas_assignments.create!(
                id_from_canvas: id_from_canvas,
                name: name,
                points_possible: points_possible
              )
              existing_assignments[id_from_canvas] = new_assignment
            rescue ActiveRecord::RecordInvalid => e
              Rails.logger.error "Failed to create CanvasAssignment: #{e.message}"
            end
          end
        end

        new_users = []
        new_enrollments = []
        submissions = []
        snapshot_id = self.id 

        csv.each_with_index do |row, index|
          next if index.zero? 

          email = row[:sis_login_id]
          user = existing_users[email] || begin
            canvas_full = row[:student] || "Unknown"
            last_name, first_name = canvas_full.split(", ")
            begin
              new_user = User.create!(
                email: email,
                password: SecureRandom.hex(16),
                first_name: first_name,
                last_name: last_name
              )
              existing_users[email] = new_user
              new_user
            rescue ActiveRecord::RecordInvalid => e
              Rails.logger.error "Failed to create User: #{e.message} - Data: #{row.inspect}"
              next
            end
          end

          enrollment = existing_enrollments[user.id] || begin
            begin
              new_enrollment = cohort.enrollments.create!(
                user: user,
                role: "student",
                id_from_canvas: row[:id]
              )
              existing_enrollments[user.id] = new_enrollment
              new_enrollment
            rescue ActiveRecord::RecordInvalid => e
              Rails.logger.error "Failed to create Enrollment: #{e.message} - User ID: #{user.id}, Cohort ID: #{cohort.id}"
              next
            end
          end

          row.each do |assignment_name_raw, points|
            next if [:id, :student, :sis_login_id, :sis_user_id, :section].include?(assignment_name_raw)

            assignment_id = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
            canvas_assignment = existing_assignments[assignment_id]
            next unless canvas_assignment

            submissions << {
              enrollment_id: enrollment.id,
              canvas_assignment_id: canvas_assignment.id,
              points: points,
              canvas_gradebook_snapshot_id: snapshot_id,
              created_at: Time.current,
              updated_at: Time.current
            }
          end
        end

        CanvasSubmission.insert_all!(submissions) unless submissions.empty?

      rescue => e
        Rails.logger.error "Transaction failed with error: #{e.message}"
        raise ActiveRecord::Rollback
      end
    end
  end
end
