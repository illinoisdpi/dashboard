class ImpressionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role? :admin
        scope.all
      else
        scope.where(id: user.pluck(:id))
      end
    end
  end

  def index?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def show?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def create?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def new?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
  
  def update?
    edit?
  end
  
  def edit?
    @user.has_role?(:admin) || @record.author_id == @user.id  
  end
  
  def destroy?
    @user.has_role?(:admin)
  end
end
