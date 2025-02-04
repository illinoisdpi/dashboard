class RecurringMessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.days.map!(&:to_i)

    if @message.save
      next_occurrence = calculate_next_occurrence(@message)
      if next_occurrence
        DiscordMessageJob.set(wait_until: next_occurrence).perform_later(@message.id)
      end
      redirect_to @message, notice: "Message scheduled successfully."
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:channel_id, :message_content, :scheduled_time, days: [])
  end

  def calculate_next_occurrence(message)
    now = Time.current
    target_seconds = message.scheduled_time.seconds_since_midnight

    candidates = message.days.map do |weekday|
      days_ahead = (weekday - now.wday) % 7
      candidate = now.beginning_of_day + days_ahead.days + target_seconds.seconds
      candidate <= now ? candidate + 1.week : candidate
    end

    candidates.min
  end
end
