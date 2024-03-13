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

      csv.each_with_index do |row, i|
        if i.zero?
          row.to_a.each_with_index do |(assignment_name_raw, points_possible), position|
            next unless points_possible.is_a?(Numeric)

            name = CanvasGradebookSnapshot.extract_assignment_name(assignment_name_raw)
            id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)

            cohort.canvas_assignments.find_or_create_by(id_from_canvas:) do |assignment|
              assignment.name = name
              assignment.points_possible = points_possible
              assignment.position = position
            end
          end
        else
          enrollment = cohort.enrollments.find_by_id_from_canvas(row.fetch(:id))

          if enrollment.blank?
            id_from_canvas = row.fetch(:id)

            next unless row.has_key?(:sis_login_id)

            email = row.fetch(:sis_login_id)

            canvas_full = row.fetch(:student, "None provided")

            user = User.find_by_email(email)

            if user.blank?
              last_name, first_name = canvas_full.split(", ")
              user = User.create(email:, password: SecureRandom.hex(16), canvas_full:, first_name:, last_name:)
            end

            # test student has invalid email and doesn't save
            next unless user.valid?

            enrollment = Enrollment.find_or_create_by(user: user, cohort: cohort) do |e|
              e.role = "student"
              e.id_from_canvas = id_from_canvas
            end
          end

          row.each do |assignment_name_raw, points|
            id_from_canvas = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
            canvas_assignment = CanvasAssignment.find_by_id_from_canvas id_from_canvas
            next if canvas_assignment.nil?

            canvas_submissions.create(enrollment:, canvas_assignment:, points:)
          end
        end
      end
    end
  end
end
