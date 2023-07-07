class CanvasGradebookSnapshotPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor?
  end

  def show?
    user.admin? || user.instructor?
  end

  def create?
    user.admin? || user.instructor?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
