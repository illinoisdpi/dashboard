class DashboardPolicy < ApplicationPolicy
  def index?
    true
  end

  def authored_impressions?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def cohorts?
    true
  end

  def recent_articles?
    true
  end
end
