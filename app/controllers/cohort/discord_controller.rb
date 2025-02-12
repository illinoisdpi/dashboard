class Cohort::DiscordController < ApplicationController
  before_action :set_cohort
  before_action :authorize_cohort_discord
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord" },
    ]

    @channels = DiscordService.new.fetch_channels(@cohort.discord_server_id)
    # TODO: Find a way to optimize this to reduce O(N)^2 before implementing
    # @server_top_contributors = DiscordService.new.top_server_contributors(@cohort.discord_server_id, 50)
    # @server_recent_messages = DiscordService.new.fetch_server_recent_messages(@cohort.discord_server_id, 10)
  end

  def show
    @channel = DiscordService.new.fetch_channel(@cohort.discord_server_id, params[:id])
    @recent_messages = DiscordService.new.fetch_recent_messages(params[:id], 10)
    @top_contributors = DiscordService.new.top_contributors(params[:id], 5)

    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord", href: cohort_discord_index_path(@cohort) },
      { content: @channel[:name] },
    ]

    @recurring_message = RecurringMessage.new(channel_id: @channel[:id])
  end

  def create

    @recurring_message = RecurringMessage.new(recurring_message_params)
    @recurring_message.cohort = @cohort

    if @recurring_message.save
      next_occurrence = calculate_next_occurrence(@recurring_message)
      if next_occurrence
        DiscordMessageJob.set(wait_until: next_occurrence).perform_later(@recurring_message.id)
      end

      flash[:notice] = "Recurring message scheduled successfully."
      redirect_to cohort_discord_path(@cohort, id: @recurring_message.channel_id)
    else
      flash.now[:alert] = "Error scheduling recurring message."
      render :show
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end

  def recurring_message_params
    params.require(:recurring_message).permit(:channel_id, :message_content, :scheduled_time, days_of_week: [])
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
