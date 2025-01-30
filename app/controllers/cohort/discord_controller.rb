class Cohort::DiscordController < ApplicationController
  before_action :set_cohort
  before_action :authorize_cohort_discord
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord" }
    ]
  
    @channels = DiscordService.new.fetch_channels(@cohort.discord_server_id)
  
    @server_top_contributors = DiscordService.new.top_server_contributors(@cohort.discord_server_id, 50)
  
    @server_recent_messages = DiscordService.new.fetch_server_recent_messages(@cohort.discord_server_id, 10)
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
  end

  def recurring_messages
    @channel_id = params[:id]
    @recurring_message = @cohort.recurring_messages.new(
      channel_id: @channel_id,
      message_content: params[:message_content],
      recurrence_pattern: params[:recurrence_pattern]
    )

    if @recurring_message.save
      next_run_at = RecurringMessageService.calculate_next_run(@recurring_message)
      @recurring_message.update(next_run_at: next_run_at)
      RecurringMessageService.schedule_next_job(@recurring_message)

      redirect_to cohort_discord_path(@cohort, id: @channel_id),
                  notice: "Recurring message scheduled successfully!"
    else
      redirect_to cohort_discord_path(@cohort, id: @channel_id),
                  alert: @recurring_message.errors.full_messages.join(", ")
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end
end
