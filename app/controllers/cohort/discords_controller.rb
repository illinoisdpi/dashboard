class Cohort::DiscordsController < ApplicationController
  before_action :set_cohort
  before_action { authorize(@cohort || Cohort, :discord?) }

  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord" },
    ]
    @channels = DiscordService.new.fetch_channels(@cohort.discord_server_id)
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

end
