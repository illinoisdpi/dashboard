class RecurringMessage < ApplicationRecord
    belongs_to :cohort
  
    enum recurrence_pattern: { daily: 0, weekly: 1, custom: 2 }
  
    validates :channel_id, :message_content, :recurrence_pattern, presence: true
    validates :cron_expression, presence: true, if: -> { recurrence_pattern == "custom" }
  end
  