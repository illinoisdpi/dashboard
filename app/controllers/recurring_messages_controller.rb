class RecurringMessagesController < ApplicationController
  before_action :set_cohort
  before_action :set_channel
  before_action :authorize_cohort_discord

  def new
    @recurring_message = @cohort.recurring_messages.new(channel_id: @channel[:id])
  end

  def edit
    @recurring_message = @cohort.recurring_messages.find(params[:id])
  end
  def create
    @recurring_message = @cohort.recurring_messages.new(recurring_message_params)
    @recurring_message.channel_id = @channel[:id]
    if @recurring_message.save
      schedule_discord_message(@recurring_message)
      flash[:notice] = "Recurring message scheduled successfully."
      redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
    else
      flash.now[:alert] = "Error scheduling recurring message."
      render :new
    end
  end


  def update
    @recurring_message = @cohort.recurring_messages.find(params[:id])
    if @recurring_message.update(recurring_message_params)
      schedule_discord_message(@recurring_message)
      flash[:notice] = "Recurring message updated successfully."
      redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
    else
      flash.now[:alert] = "Error updating recurring message."
      render :edit
    end
  end

  def destroy
    @recurring_message = @cohort.recurring_messages.find(params[:id])
    @recurring_message.destroy
    flash[:notice] = "Recurring message deleted."
    redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_channel
    @channel = DiscordService.new.fetch_channel(@cohort.discord_server_id, params[:discord_channel_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end

  def recurring_message_params
    params.require(:recurring_message).permit(:message_content, :scheduled_time, days_of_week: [])
  end

  def schedule_discord_message(recurring_message)
    next_occurrence = calculate_next_occurrence(recurring_message)
    if next_occurrence
      DiscordMessageJob
        .set(wait_until: next_occurrence)
        .perform_later(recurring_message.id)
    end
  end

  def calculate_next_occurrence(recurring_message)
    now = Time.current
    target_seconds = Time.parse(recurring_message.scheduled_time.to_s).seconds_since_midnight

    weekdays = recurring_message.days_of_week.map do |day|
      Date::DAYNAMES.index(day.capitalize)
    end.compact

    candidates = weekdays.map do |weekday|
      days_ahead = (weekday - now.wday) % 7
      candidate = now.beginning_of_day + days_ahead.days + target_seconds.seconds
      candidate <= now ? candidate + 1.week : candidate
    end

    candidates.min
  end
end
