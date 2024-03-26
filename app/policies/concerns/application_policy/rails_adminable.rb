module ApplicationPolicy::RailsAdminable
  extend ActiveSupport::Concern

  def dashboard?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def export?
    user.admin? || user.instructor?
  end

  def history?
    user.admin?
  end

  def show_in_app?
    user.admin?
  end
end
