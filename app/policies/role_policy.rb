class RolePolicy < ApplicationPolicy
  def index?
    admin? || instructor? || teaching_assistant?
  end
  
  def show?
    admin? || instructor? || teaching_assistant?
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
