# == Schema Information
#
# Table name: canvas_gradebook_snapshots
#
#  id            :uuid             not null, primary key
#  csv_filename  :string
#  downloaded_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cohort_id     :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_canvas_gradebook_snapshots_on_cohort_id  (cohort_id)
#  index_canvas_gradebook_snapshots_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
class CanvasGradebookSnapshot < ApplicationRecord
  attr_accessor :csv_file

  belongs_to :cohort
  belongs_to :user
  has_many :canvas_submissions
  has_many :enrollments, -> { distinct }, through: :canvas_submissions
  has_many :canvas_assignments, -> { distinct }, through: :canvas_submissions

  validates :csv_file, presence: true

  after_create :process_csv

  scope :default_order, -> { order(downloaded_at: :desc) }

  def to_s
    downloaded_at_humanized
  end

  def downloaded_at_humanized
    downloaded_at.strftime("%Y-%m-%d")
  end

  def process_csv
    ActiveRecord::Base.transaction do
      self.update(csv_filename: csv_file.original_filename)

      csv = SmarterCSV.process(csv_file)

      csv.each_with_index do |row, i|
        if i.zero?
          row.each do |assignment_name_raw, points_possible|
            next unless points_possible.is_a?(Numeric)

            name_array = assignment_name_raw.to_s.split("_")
            id_from_canvas = name_array.pop.gsub(/\D/, '')
            name = name_array.join(' ')
            # TODO: add position
            CanvasAssignment.find_or_create_by(cohort:, points_possible:, id_from_canvas:, name:)
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

          # loop through all keys for canvas_assignment/points
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
