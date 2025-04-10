class DiscordChannelsController < ApplicationController
  before_action :set_cohort
  before_action :authorize_cohort_discord
  skip_after_action :verify_policy_scoped, only: [ :index ]

  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord" }
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
      { content: "Discord Channels", href: cohort_discord_channels_path(@cohort) },
      { content: @channel[:name] }
    ]

    @recurring_messages = @cohort.recurring_messages.where(channel_id: @channel[:id])
    @recurring_message = @cohort.recurring_messages.new(channel_id: @channel[:id])
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end
end
