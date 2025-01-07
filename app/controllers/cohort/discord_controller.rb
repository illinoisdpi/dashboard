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
  end

  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord", href: cohort_discord_index_path(@cohort) },
      { content: "Channel" }
    ]
    # @channel = DiscordService.new.fetch_channel(@cohort.discord_server_id, params[:channel_id])
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end

end
