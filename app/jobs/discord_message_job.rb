class DiscordMessageJob < ApplicationJob
  queue_as :discord

  def perform(message_id)
    message = RecurringMessage.find_by(id: message_id)
    return unless message

    DiscordService.new.send_message(message.channel_id, message.message_content)

    next_occurrence = message.calculate_next_occurrence
    if next_occurrence
      self.class.set(wait_until: next_occurrence).perform_later(message.id)
    end
  end
end
