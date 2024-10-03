# == Schema Information
#
# Table name: cohorts
#
#  id                   :uuid             not null, primary key
#  canvas_shortname     :string
#  generation           :integer          not null
#  name                 :string
#  number               :integer          not null
#  piazza_course_number :string
#  started_on           :date
#  year                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Cohort < ApplicationRecord
  include Adminable

  has_paper_trail skip: [:created_at, :updated_at]

  has_many :enrollments, dependent: :destroy
  has_many :piazza_activity_reports, dependent: :destroy
  has_many :canvas_gradebook_snapshots, dependent: :destroy
  has_many :canvas_assignments, dependent: :destroy
  has_many :included_canvas_assignments, -> { included }, class_name: "CanvasAssignment"
  has_many :impressions, through: :enrollments, source: :impressions
  has_many :users, through: :enrollments, source: :user

  validates :year, presence: true
  validates :generation, presence: true
  validates :number,
    presence: true,
    uniqueness: {scope: ["generation", "year"]}
  validates :started_on, presence: true

  scope :default_order, -> { order(:year, :generation, :number) }

  def to_s
    "[#{code}] #{name}"
  end

  def code
    "#{year}-#{generation}.#{number}"
  end

  def inactive_enrollments
    enrollments
      .joins(:user)
      .left_joins(:canvas_submissions)
      .where(enrollments: { role: "student" })
      .where("canvas_submissions.id IS NULL OR (canvas_submissions.points <= 0 AND canvas_submissions.created_at < ?)", 4.weeks.ago)
      .select("users.first_name || ' ' || users.last_name AS full_name")
      .group("users.id")
  end
end
