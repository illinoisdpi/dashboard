# == Schema Information
#
# Table name: recurring_messages
#
#  id                 :uuid             not null, primary key
#  days_of_week       :string           default([]), is an Array
#  enabled            :boolean          default(TRUE)
#  message_content    :text
#  next_run_at        :datetime
#  recurrence_pattern :integer          default(0)
#  scheduled_time     :time
#  skip_weekends      :boolean
#  timezone           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  channel_id         :string
#  cohort_id          :uuid
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

  validates :message_content, presence: true
  validates :scheduled_time, presence: true
  validates :days_of_week, presence: true, 
    inclusion: { in: DAYS, message: "%{value} is not a valid day" },
    length: { minimum: 1 }

  before_create :set_initial_schedule

  private

  def set_initial_schedule
    self.next_run_at = RecurringMessageService.calculate_initial_run(self)
  end
end
