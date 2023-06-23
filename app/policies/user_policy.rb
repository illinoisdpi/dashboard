class UserPolicy < ApplicationPolicy
  def index?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def show?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def create?
    [:admin].any? { |role| @user.has_role?(role) }
  end
  
  def new?
    create?
  end
  
  def update?
    edit?
  end
  
  def edit?
    @user.has_role?(:admin) || @record.id == @user.id 
  end
  
  def destroy?
    create?
  end
end
