module Roleable
  extend ActiveSupport::Concern

  protected

  def admin?
    user.has_role? :admin
  end

  def instructor?
    user.has_role? :instructor
  end

  def teaching_assistant?
    user.has_role? :teaching_assistant
  end
end
