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

            cohort.canvas_assignments.find_or_create_by(id_from_canvas:) do |assignment|
              assignment.name = name
              assignment.points_possible = points_possible
              assignment.position = position
            end
          end
        else

          enrollment = cohort.enrollments.find_by_id_from_canvas row.fetch(:id)
          next if enrollment.blank?

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
