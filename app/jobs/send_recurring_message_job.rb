class SendRecurringMessageJob < ApplicationJob
    queue_as :default
  
    def perform(recurring_message_id)
      rm = RecurringMessage.find_by(id: recurring_message_id)
      return unless rm && rm.enabled
  
      DiscordService.new.send_message(rm.channel_id, rm.message_content)
  
      next_run = RecurringMessageService.calculate_next_run(rm)
      rm.update(next_run_at: next_run)
  
      RecurringMessageService.schedule_next_job(rm)
    end
  end
  