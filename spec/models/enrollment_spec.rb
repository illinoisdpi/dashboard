# == Schema Information
#
# Table name: enrollments
#
#  id                             :uuid             not null, primary key
#  career_attendance              :integer          default(0)
#  career_calendar_management     :integer          default(0)
#  career_customer_service        :integer          default(0)
#  career_networking              :integer          default(0)
#  career_problem_solving         :integer          default(0)
#  career_punctuality             :integer          default(0)
#  career_quality_of_work         :integer          default(0)
#  career_response_to_supervision :integer          default(0)
#  career_summary                 :text
#  career_taking_initiative       :integer          default(0)
#  career_task_management         :integer          default(0)
#  career_teamwork                :integer          default(0)
#  career_total                   :integer          default(0)
#  career_workplace_appearance    :integer          default(0)
#  career_workplace_culture       :integer          default(0)
#  communication_nonverbal        :integer          default(0)
#  communication_summary          :text
#  communication_total            :integer          default(0)
#  communication_verbal           :integer          default(0)
#  communication_written          :integer          default(0)
#  emotional_intelligence         :text
#  id_from_canvas                 :string
#  role                           :string
#  skills_development             :text
#  staff_areas_for_growth         :text
#  staff_strengths                :text
#  technical_good_questions       :integer          default(0)
#  technical_progress             :integer          default(0)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cohort_id                      :uuid             not null
#  user_id                        :uuid             not null
#
# Indexes
#
#  index_enrollments_on_cohort_id       (cohort_id)
#  index_enrollments_on_id_from_canvas  (id_from_canvas)
#  index_enrollments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Enrollment do
  pending "add some examples to (or delete) #{__FILE__}"
end
