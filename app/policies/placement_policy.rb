class PlacementPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def show?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def create?
    new?
  end

  def new?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def update?
    edit?
  end

  def edit?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def destroy?
    user.admin?
  end

  def search?
    true
  end
end
