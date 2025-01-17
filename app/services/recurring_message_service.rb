class RecurringMessageService
    # Calculates the next run time for a recurring message based on its pattern.
    # This example handles 'daily', 'weekly', and 'custom' (cron-based).
    #
    # @param recurring_message [RecurringMessage]
    # @return [Time] the next time the message should be sent
    def self.calculate_next_run(recurring_message)
      case recurring_message.recurrence_pattern
      when "daily"
        base_time = [Time.current, recurring_message.next_run_at || Time.current].max
        base_time + 1.day
      when "weekly"
        base_time = [Time.current, recurring_message.next_run_at || Time.current].max
        base_time + 1.week
      when "custom"
        # TODO: Implement this when we fix UI
        # require "fugit"
        # cron = Fugit::Cron.parse(recurring_message.cron_expression)
        # cron.next_time(Time.current).to_time
      else
        Time.current
      end
    end
  
    def self.schedule_next_job(recurring_message)
      return unless recurring_message.enabled
      return if recurring_message.next_run_at.blank?
      return if recurring_message.next_run_at <= Time.current
  
      SendRecurringMessageJob
        .set(wait_until: recurring_message.next_run_at)
        .perform_later(recurring_message.id)
    end
  end
  