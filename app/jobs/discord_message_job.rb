class DiscordMessageJob < ApplicationJob
  queue_as :discord

  def perform(message_id)
    message = RecurringMessage.find_by(id: message_id)
    message.devliver_message
  end
end
