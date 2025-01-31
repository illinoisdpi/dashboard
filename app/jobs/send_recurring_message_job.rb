class SendRecurringMessageJob < ApplicationJob
  queue_as :default

  def perform(recurring_message_id)
    message = RecurringMessage.find_by(id: recurring_message_id)
    return unless message&.enabled?

    DiscordService.new.send_message(message.channel_id, message.message_content)
    
    new_time = RecurringMessageService.calculate_next_run(message)
    message.update!(next_run_at: new_time)
    SendRecurringMessageJob.set(wait_until: new_time).perform_later(message.id)
  end
end
