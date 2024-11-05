# == Schema Information
#
# Table name: canvas_assignments
#
#  id              :uuid             not null, primary key
#  authentication  :integer
#  css             :integer
#  databases       :integer
#  domain_modeling :integer
#  excluded        :boolean          default(FALSE)
#  html            :integer
#  id_from_canvas  :string
#  javascript      :integer
#  name            :string
#  points_possible :integer
#  position        :integer
#  rails           :integer
#  ruby            :integer
#  weight          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cohort_id       :uuid             not null
#
# Indexes
#
#  index_canvas_assignments_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
class CanvasAssignment < ApplicationRecord
  include Adminable

  has_paper_trail skip: [ :created_at, :updated_at ]

  belongs_to :cohort
  has_many :canvas_submissions
  has_many :enrollments, through: :cohort

  scope :default_order, -> { order(position: :asc) }
  scope :included, -> { where(excluded: false) }
  scope :group_by_highest_position_submission_count, -> {
    joins(:canvas_submissions, :enrollments)
      .where(enrollments: { role: "student" })
      .where("canvas_assignments.position = (SELECT MAX(position) FROM canvas_assignments INNER JOIN canvas_submissions ON canvas_assignments.id = canvas_submissions.canvas_assignment_id WHERE canvas_submissions.points > 0 AND enrollments.id = canvas_submissions.enrollment_id)")
      .group("canvas_assignments.id", "canvas_assignments.name", "canvas_assignments.position")
      .order("canvas_assignments.position ASC")
      .select("canvas_assignments.name", "COUNT(DISTINCT enrollments.id) AS student_count")
  }
end
