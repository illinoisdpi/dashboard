class ImpressionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin? || instructor?
        scope.all
      else
        scope.where(author_id: user.id)
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
    admin? || record.author == user
  end

  def destroy?
    admin? || record.author == user
  end
end
