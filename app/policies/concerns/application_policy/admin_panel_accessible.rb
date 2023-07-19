module ApplicationPolicy::AdminPanelAccessible
  extend ActiveSupport::Concern

  def admin_panel_accessible?
    dashboard?
  end

  def sidekiq_panel_accessible?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def blazer_panel_accessible?
    user.admin? || user.instructor?
  end
end
