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

      name_array.take(name_array.length - 1).join(' ')
    end

    def extract_id_from_canvas(assignment_name_raw)
      assignment_name_raw.to_s.split("_").pop.gsub(/\D/, '')
    end

    def extract_downloaded_at(csv_filename)
      DateTime.strptime(csv_filename.split("_").at(0), '%Y-%m-%dT%H%M')
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
      csv = SmarterCSV.process(csv_file)
  
      header_row = csv.first
  
      assignment_headers = []
      header_row.to_a.each_with_index do |(assignment_name_raw, points_possible), position|
        next unless points_possible.is_a?(Numeric)
  
        id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
        name = CanvasGradebookSnapshot.extract_assignment_name(assignment_name_raw)
        assignment_headers << {
          id_from_canvas: id_from_canvas,
          name: name,
          points_possible: points_possible,
          position: position,
          cohort_id: cohort.id,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
  
      assignment_ids = assignment_headers.map { |a| a[:id_from_canvas] }
      existing_assignments = cohort.canvas_assignments
                                   .where(id_from_canvas: assignment_ids)
                                   .index_by(&:id_from_canvas)
  
      new_assignments = assignment_headers.reject do |assignment|
        existing_assignments.key?(assignment[:id_from_canvas])
      end
  
      CanvasAssignment.insert_all(new_assignments) unless new_assignments.empty?
  
      existing_assignments = cohort.canvas_assignments
                                   .where(id_from_canvas: assignment_ids)
                                   .index_by(&:id_from_canvas)
  
      student_rows = csv[1..-1] # Exclude header row
  
      emails = student_rows.map { |row| row[:sis_login_id] }.compact.uniq
  
      existing_users = User.where(email: emails).index_by(&:email)
  
      new_users = []
      student_rows.each do |row|
        email = row[:sis_login_id]
        next unless email
        next if existing_users.key?(email)
  
        canvas_full = row.fetch(:student, "None provided")
        last_name, first_name = canvas_full.split(", ")
        new_users << {
          email: email,
          password: SecureRandom.hex(16),
          canvas_full: canvas_full,
          first_name: first_name,
          last_name: last_name,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
  
      User.insert_all(new_users) unless new_users.empty?
  
      existing_users = User.where(email: emails).index_by(&:email)
  
      user_ids = existing_users.values.map(&:id)
      existing_enrollments = cohort.enrollments
                                   .where(user_id: user_ids)
                                   .index_by(&:user_id)
  
      new_enrollments = []
      student_rows.each do |row|
        email = row[:sis_login_id]
        next unless email
  
        user = existing_users[email]
        next unless user
        next if existing_enrollments.key?(user.id)
  
        new_enrollments << {
          user_id: user.id,
          cohort_id: cohort.id,
          role: "student",
          id_from_canvas: row[:id],
          created_at: Time.current,
          updated_at: Time.current
        }
      end
  
      Enrollment.insert_all(new_enrollments) unless new_enrollments.empty?
  
      existing_enrollments = cohort.enrollments
                                   .where(user_id: user_ids)
                                   .index_by(&:user_id)
  
      # **Include the canvas_gradebook_snapshot_id**
      snapshot_id = self.id 
  
      submissions = []
      student_rows.each do |row|
        email = row[:sis_login_id]
        next unless email
  
        user = existing_users[email]
        enrollment = existing_enrollments[user.id]
        next unless enrollment
  
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
  
      CanvasSubmission.insert_all(submissions) unless submissions.empty?
    end
  end
  
end
