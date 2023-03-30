module CanvasGradebookSnapshot::Csvable
  extend ActiveSupport::Concern

  included do
    attr_accessor :csv_file
    validates :csv_file, presence: true
    after_create :process_csv
  end

  def process_csv
    ActiveRecord::Base.transaction do
      self.update(csv_filename: csv_file.original_filename)

      csv = SmarterCSV.process(csv_file)

      csv.each_with_index do |row, i|
        if i.zero?
          row.to_a.each_with_index do |(assignment_name_raw, points_possible), position|
            next unless points_possible.is_a?(Numeric)

            name_array = assignment_name_raw.to_s.split("_")
            id_from_canvas = name_array.pop.gsub(/\D/, '')
            name = name_array.join(' ')

            CanvasAssignment.find_or_create_by(cohort:, points_possible:, id_from_canvas:, name:, position:)
          end
        else

          emails = row.fetch(:sis_login_id).split(";").map(&:strip)
          user = User.where(email: emails).first

          if user.blank?
            # TODO: add User#canvas_full col?
            user = User.create(email: emails.first, password: SecureRandom.hex(16))       
          end

          enrollment = Enrollment.find_or_create_by(user:, cohort:) do |the_enrollment|
            the_enrollment.id_from_canvas = row.fetch(:id)
          end

          row.each do |assignment_name_raw, points|
            id_from_canvas = assignment_name_raw.to_s.split("_").pop.gsub(/\D/, '')
            canvas_assignment = CanvasAssignment.find_by_id_from_canvas id_from_canvas
            next if canvas_assignment.nil?

            canvas_submissions.create(enrollment:, canvas_assignment:, points:)
          end
        end
      end
    end
  end
end
