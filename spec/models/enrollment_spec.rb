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
require "rails_helper"

RSpec.describe Enrollment do
  pending "add some examples to (or delete) #{__FILE__}"
end
