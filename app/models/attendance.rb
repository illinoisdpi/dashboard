# == Schema Information
#
# Table name: attendances
#
#  id               :uuid             not null, primary key
#  category         :string
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cohort_id        :uuid
#  roll_taker_id_id :uuid             not null
#
# Indexes
#
#  index_attendances_on_cohort_id         (cohort_id)
#  index_attendances_on_roll_taker_id_id  (roll_taker_id_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (roll_taker_id_id => users.id)
#
class Attendance < ApplicationRecord
end
