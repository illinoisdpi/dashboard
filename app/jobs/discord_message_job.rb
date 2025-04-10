class DiscordMessageJob < ApplicationJob
  queue_as :discord

  def perform(message_id)
    message = RecurringMessage.find_by(id: message_id)
    message.deliver_message
  end
end
