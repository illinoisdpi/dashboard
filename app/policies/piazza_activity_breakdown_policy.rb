class PiazzaActivityBreakdownPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor? || user.teaching_assistant?
  end
  
  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end
  
  def create?
    user.admin?
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
