# == Schema Information
#
# Table name: recurring_messages
#
#  id              :uuid             not null, primary key
#  days_of_week    :text             default([]), is an Array
#  message_content :text
#  scheduled_time  :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  channel_id      :string
#  cohort_id       :uuid
#
# Indexes
#
#  index_recurring_messages_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
class RecurringMessage < ApplicationRecord
  DAYS = %w[monday tuesday wednesday thursday friday saturday sunday].freeze

  serialize :days, Array

  validates :message_content, presence: true
  validates :scheduled_time, presence: true
  validates :days_of_week, presence: true, 
    inclusion: { in: DAYS, message: "%{value} is not a valid day" },
    length: { minimum: 1 }

end
