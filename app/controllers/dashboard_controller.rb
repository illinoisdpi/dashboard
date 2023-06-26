class DashboardController < ApplicationController
  def index
    @breadcrumbs = [
      {content: "Dashboard", href: dashboard_root_path}
    ]

    @cohorts = Cohort.all.default_order
    @impressions = current_user.authored_impressions.default_order.take(5)
    @articles = DevtoArticle.default_order.take(5)
  end
end
