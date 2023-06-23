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
    user.has_role?(:admin) || user.cohorts.include?(record)
  end

  def index?
    true
  end

  def edit?
    user.has_role?(:admin) || user.has_role?(:instructor)
  end

  def update?
    user.has_role?(:admin) || user.has_role?(:instructor)
  end

  def create?
    user.has_role?(:admin) || user.has_role?(:instructor)
  end

  def destroy?
    user.has_role?(:admin)
  end

  def new?
    user.has_role?(:admin) || user.has_role?(:instructor)
  end
end