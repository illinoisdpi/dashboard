class CohortPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role? :admin
        scope.all
      else
        scope.where(id: user.cohorts.pluck(:id))
      end
    end
  end

  def show?
    admin? || user.cohorts.include?(record)
  end

  def index?
    true
  end

  def edit?
    admin? || instructor?
  end

  def update?
    admin? || instructor?
  end

  def create?
    admin? || instructor?
  end

  def destroy?
    admin?
  end

  def new?
    admin? || instructor?
  end

  def piazza_post_views
    admin? || instructor?
  end

  def piazza_posts
    admin? || instructor?
  end
end