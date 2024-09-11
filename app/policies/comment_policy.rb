class CommentPolicy < ApplicationPolicy
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
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def show?
    user.admin? || user.instructor? || user.teaching_assistant? || (record.is_a?(Impression) && user == record.author)
  end

  def create?
    new?
  end

  def new?
    user.admin? || user.instructor? || user.teaching_assistant? || user.staff?
  end

  def update?
    edit?
  end

  def edit?
    user.admin? || (record.is_a?(Impression) && user == record.author)
  end

  def destroy?
    user.admin? || user.instructor? || (record.is_a?(Impression) && user == record.author)
  end

  def search?
    new?
  end
end
