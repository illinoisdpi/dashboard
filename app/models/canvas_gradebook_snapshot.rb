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
  include Csvable

  has_paper_trail skip: [:created_at, :updated_at]

  belongs_to :cohort
  belongs_to :user
  has_many :canvas_submissions, dependent: :destroy
  has_many :enrollments, -> { distinct }, through: :canvas_submissions
  has_many :canvas_assignments, -> { distinct }, through: :canvas_submissions

  scope :default_order, -> { order(downloaded_at: :desc) }

  def to_s
    downloaded_at_humanized
  end

  def downloaded_at_humanized
    downloaded_at.strftime("%Y-%m-%d")
  end

  def total_points_for(enrollment)
    canvas_submissions.where(enrollment: enrollment).sum(:points)
  end

  def total_points_possible_for(enrollment)
    enrollment.cohort.canvas_assignments.included.sum(:points_possible)
  end

  def full_points?(enrollment)
    total_points_for(enrollment) >= total_points_possible_for(enrollment)
  end

  def update_canvas_full_points_for_all_enrollments
    enrollments.each do |enrollment|
      enrollment.update_column(:canvas_full_points, full_points?(enrollment))
    end
  end

  after_save :update_canvas_full_points_for_all_enrollments
end
