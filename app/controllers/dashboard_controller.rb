class DashboardController < ApplicationController
  before_action { authorize(:dashboard) }

  def index
    @breadcrumbs = [
      {content: "Dashboard", href: dashboard_root_path}
    ]

    @cohorts = policy_scope(Cohort).all.default_order
    @impressions = policy_scope(current_user.authored_impressions).default_order.take(5)
    @articles = policy_scope(DevtoArticle).default_order.take(5)
    @placements = policy_scope(Placement).take(5)
  end
end
