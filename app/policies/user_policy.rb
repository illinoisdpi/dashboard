class UserPolicy < ApplicationPolicy
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
    edit?
  end
  
  def edit?
    user.admin? || record.id == user.id 
  end
  
  def destroy?
    create?
  end
end
