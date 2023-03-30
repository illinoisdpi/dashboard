# == Schema Information
#
# Table name: enrollments
#
#  id                             :uuid             not null, primary key
#  career_attendance              :integer
#  career_calendar_management     :integer
#  career_customer_service        :integer
#  career_networking              :integer
#  career_problem_solving         :integer
#  career_punctuality             :integer
#  career_quality_of_work         :integer
#  career_response_to_supervision :integer
#  career_summary                 :text
#  career_taking_initiative       :integer
#  career_task_management         :integer
#  career_teamwork                :integer
#  career_total                   :integer
#  career_workplace_appearance    :integer
#  career_workplace_culture       :integer
#  communication_nonverbal        :integer
#  communication_summary          :text
#  communication_total            :integer
#  communication_verbal           :integer
#  communication_written          :integer
#  emotional_intelligence         :text
#  id_from_canvas                 :string
#  role                           :string
#  staff_areas_for_growth         :text
#  staff_strengths                :text
#  technical_good_questions       :integer
#  technical_progress             :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cohort_id                      :uuid             not null
#  user_id                        :uuid             not null
#
# Indexes
#
#  index_enrollments_on_cohort_id       (cohort_id)
#  index_enrollments_on_id_from_canvas  (id_from_canvas) UNIQUE
#  index_enrollments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
class Enrollment < ApplicationRecord
  include Adminable
  belongs_to :user
  belongs_to :cohort
  has_many :piazza_activity_breakdowns, dependent: :destroy
  has_many :canvas_submissions, dependent: :destroy

  scope :default_order, -> { joins(:user).order(User.arel_table[:piazza_full].asc) }

  scope :student, -> { where(role: "student") }
  scope :not_student, -> { where.not(role: "student") }

  delegate :education,
    :github_username,
    :languages,
    :most_recent_role,
    :personal_website,
    :quote,
    :strengths,
    :to_s,
    to: :user

  before_validation :set_career_total
  before_validation :set_communication_total

  def set_career_total
    self.career_total = career_attendance +
      career_punctuality +
      career_workplace_appearance +
      career_workplace_culture +
      career_taking_initiative +
      career_quality_of_work +
      career_networking +
      career_response_to_supervision +
      career_teamwork +
      career_customer_service +
      career_problem_solving +
      career_calendar_management +
      career_task_management
  end

  def set_communication_total
    self.communication_total = communication_nonverbal +
      communication_verbal +
      communication_written
  end
end
