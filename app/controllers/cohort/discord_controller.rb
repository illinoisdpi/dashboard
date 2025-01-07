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
    @cohort = Cohort.find(params[:cohort_id])

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

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end
end
