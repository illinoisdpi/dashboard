class CanvasAssignmentPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def index?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def new?
    user.admin?
  end
end
