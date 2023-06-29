class UserPolicy < ApplicationPolicy
  def index?
    admin? || instructor? || ta?
  end
  
  def show?
    admin? || instructor? || ta?
  end
  
  def create?
    admin?
  end
  
  def new?
    create?
  end
  
  def update?
    edit?
  end
  
  def edit?
    admin? || record.id == user.id 
  end
  
  def destroy?
    create?
  end
end
