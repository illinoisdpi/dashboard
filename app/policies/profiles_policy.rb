class ProfilesPolicy < ApplicationPolicy
  def index?
    true
  end
  
  def show?
    true
  end
  
  def create?
    [:admin].any? { |role| @user.has_role?(role) }
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
