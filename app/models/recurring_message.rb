# == Schema Information
#
# Table name: recurring_messages
#
#  id                 :uuid             not null, primary key
#  cron_expression    :string
#  enabled            :boolean          default(TRUE)
#  message_content    :text
#  next_run_at        :datetime
#  recurrence_pattern :integer          default("daily")
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
    belongs_to :cohort
  
    enum recurrence_pattern: { daily: 0, weekly: 1, custom: 2 }
  
    validates :channel_id, :message_content, :recurrence_pattern, presence: true
    validates :cron_expression, presence: true, if: -> { recurrence_pattern == "custom" }
  end
  
