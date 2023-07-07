class ImpressionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? || user.instructor?
        scope.all
      else
        scope.where(author_id: user.id)
      end
    end
  end

  def index?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def create?
    new?
  end

  def new?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def update?
    edit?
  end

  def edit?
    user.admin? || record.author == user
  end

  def destroy?
    user.admin? || record.author == user
  end
end
