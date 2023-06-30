class CanvasGradebookSnapshotPolicy < ApplicationPolicy
  def index?
    admin? || instructor?
  end
  
  def show?
    admin? || instructor?
  end
  
  def create?
    admin?
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
