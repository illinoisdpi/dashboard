class RecurringMessagePolicy < ApplicationPolicy
  # TODO: Verify
  def index?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def create?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.instructor?
  end

  def edit?
    user.admin? || user.instructor?
  end

  def destroy?
    user.admin? || user.instructor?
  end
end
