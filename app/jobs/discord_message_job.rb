class DiscordMessageJob < ApplicationJob
  queue_as :discord

  def perform(message_id)
    message = RecurringMessage.find_by(id: message_id)
    return unless message

    DiscordService.new.send_message(message.channel_id, message.message_content)

    next_occurrence = calculate_next_occurrence(message)
    if next_occurrence
      self.class.set(wait_until: next_occurrence).perform_later(message.id)
    end
  end

  private

  def calculate_next_occurrence(message)
    now = Time.current
    target_seconds = message.scheduled_time.seconds_since_midnight

    candidates = message.days_of_week.map do |day|
      weekday_index = Date::DAYNAMES.index(day.capitalize)
      next unless weekday_index

      days_ahead = (weekday_index - now.wday) % 7
      candidate = now.beginning_of_day + days_ahead.days + target_seconds.seconds
      candidate <= now ? candidate + 1.week : candidate
    end.compact

    candidates.min
  end
end
