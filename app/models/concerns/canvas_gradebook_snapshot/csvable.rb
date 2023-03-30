module CanvasGradebookSnapshot::Csvable
  extend ActiveSupport::Concern

  included do
    attr_accessor :csv_file

    validates :csv_file, presence: true
    validates :csv_filename, uniqueness: true, format: { with: ->(canvas_gradebook_snapshot) { /\A.*#{Regexp.escape(canvas_gradebook_snapshot.cohort.canvas_shortname)}.*\z/ }, message: "must contain canvas shortname belonging to this cohort" }

    before_validation :process_csv_filename
    after_create :process_csv
  end

  def process_csv_filename
    self.csv_filename = csv_file.original_filename
    self.downloaded_at = CanvasGradebookSnapshot.extract_downloaded_at(csv_filename)
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

            CanvasAssignment.find_or_create_by(cohort:, points_possible:, id_from_canvas:, name:, position:)
          end
        else

          emails = row.fetch(:sis_login_id).split(";").map(&:strip)
          user = User.where(email: emails).first

          # TODO: don't create user/enrollment. lookup by id_from_canvas so we don't mistakenly add to cohort
          if user.blank?
            user = User.new(email: emails.first, password: SecureRandom.hex(16))       
          end

          user.canvas_full = row.fetch(:student, "None provided")
          user.save

          enrollment = Enrollment.find_or_create_by(user:, cohort:) do |e|
            e.id_from_canvas = row.fetch(:id)
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
end
