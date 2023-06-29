class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role? :admin
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

  def index?
    true
  end
  
  def show?
    true
  end
  
  def snapshot?
    true
  end
end
