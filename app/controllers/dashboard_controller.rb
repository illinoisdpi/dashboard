class DashboardController < ApplicationController
  def index
    @cohorts = Cohort.all.default_order
    @impressions = current_user.authored_impressions.take(5)
  end
end
