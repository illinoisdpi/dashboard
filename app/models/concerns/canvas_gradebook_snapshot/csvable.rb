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

      headers = [ "User", "Role", "Salesforce ID" ] + canvas_assignments.map(&:name)
      csv << headers

      points_possible_row = [ "Points Possible", "", "" ] + canvas_assignments.map(&:points_possible)
      csv << points_possible_row

      self.enrollments.each do |enrollment|
        canvas_submissions = canvas_submissions_by_enrollment[enrollment.id].index_by(&:canvas_assignment_id)

        row = [
          enrollment.user.to_s,
          enrollment.role.to_s,
          enrollment.user.salesforce_id.to_s
        ]

        canvas_assignments.each do |canvas_assignment|
          points = canvas_submissions[canvas_assignment.id]&.points || ""
          row << points
        end

        csv << row
      end
    end
  end

  def process_csv_filename
    raise MissingCsvFileError.new("Please select a CSV file") if csv_file.blank?
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
    if cohort.canvas_shortname.blank?
      raise InvalidCanvasShortnameError.new("Please add canvas shortname to selected cohort")
    end

    canvas_shortname_regex = Regexp.new(Regexp.escape(cohort.canvas_shortname))
    unless canvas_shortname_regex.match?(csv_filename)
      raise InvalidCanvasShortnameError.new("Invalid canvas shortname in CSV filename. Expected format: '#{cohort.canvas_shortname}'")
    end
  end

  def process_csv
    ActiveRecord::Base.transaction do
      csv_data = load_csv_file
      snapshot_id = id

      existing_assignments = cohort.canvas_assignments.index_by(&:id_from_canvas)
      existing_users = build_existing_users(csv_data)
      existing_enrollments = cohort.enrollments.index_by(&:user_id)

      process_assignment_headers(csv_data.first, existing_assignments)

      submissions = csv_data.each_with_index.flat_map do |row, index|
        next if index.zero?
        process_csv_row(row, existing_users, existing_assignments, existing_enrollments, snapshot_id)
      end.compact

      CanvasSubmission.create!(submissions) if submissions.present?
    end
  end

  private

  def load_csv_file
    SmarterCSV.process(csv_file.path, file_encoding: "utf-8")
  end

  def build_existing_users(csv_data)
    emails = csv_data.map { |row| row[:sis_login_id] }.compact.uniq
    User.where(email: emails).index_by(&:email)
  end

  def process_assignment_headers(header_row, existing_assignments)
    header_row.each do |assignment_name_raw, points_possible|
      next unless points_possible.is_a?(Numeric)

      id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
      name = CanvasGradebookSnapshot.extract_assignment_name(assignment_name_raw)
      unless existing_assignments.key?(id_from_canvas)
        new_assignment = cohort.canvas_assignments.new(
          id_from_canvas: id_from_canvas,
          name: name,
          points_possible: points_possible
        )
        if new_assignment.save
          existing_assignments[id_from_canvas] = new_assignment
        else
          Rails.logger.error "Failed to create CanvasAssignment: #{new_assignment.errors.full_messages.join(", ")}"
        end
      end
    end
  end

  def process_csv_row(row, existing_users, existing_assignments, existing_enrollments, snapshot_id)
    user = find_or_create_user(row, existing_users)
    return unless user

    enrollment = find_or_create_enrollment(row, user, existing_enrollments)
    return unless enrollment

    extract_submissions_from_row(row, enrollment, existing_assignments, snapshot_id)
  end

  def find_or_create_user(row, existing_users)
    email = row[:sis_login_id]
    return existing_users[email] if existing_users[email]

    canvas_full = row[:student] || "Unknown"
    last_name, first_name = canvas_full.split(", ")
    new_user = User.new(
      email: email,
      password: SecureRandom.hex(16),
      first_name: first_name,
      last_name: last_name
    )
    if new_user.save
      existing_users[email] = new_user
      new_user
    else
      Rails.logger.error "Failed to create User: #{new_user.errors.full_messages.join(", ")} - Data: #{row.inspect}"
      nil
    end
  end

  def find_or_create_enrollment(row, user, existing_enrollments)
    return existing_enrollments[user.id] if existing_enrollments[user.id]

    new_enrollment = cohort.enrollments.new(
      user: user,
      role: "student",
      id_from_canvas: row[:id]
    )
    if new_enrollment.save
      existing_enrollments[user.id] = new_enrollment
      new_enrollment
    else
      Rails.logger.error "Failed to create Enrollment: #{new_enrollment.errors.full_messages.join(", ")} - User ID: #{user.id}, Cohort ID: #{cohort.id}"
      nil
    end
  end

  def extract_submissions_from_row(row, enrollment, existing_assignments, snapshot_id)
    submissions = []
    row.each do |assignment_name_raw, points|
      next if [ :id, :student, :sis_login_id, :sis_user_id, :section ].include?(assignment_name_raw)

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
    submissions
  end
end
