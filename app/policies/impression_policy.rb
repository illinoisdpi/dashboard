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
    admin? || instructor? || teaching_assistant?
  end

  def show?
    admin? || instructor? || teaching_assistant?
  end

  def create?
    new?
  end

  def new?
    admin? || instructor? || teaching_assistant?
  end

  def update?
    edit?
  end

  def edit?
    admin? || @record.author_id == @user.id  
  end

  def destroy?
    admin?
  end
end
