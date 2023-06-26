class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.has_role? :admin
        scope.all
      else
        # I'm not sure of this:
        scope.where(user_id: user.cohorts.pluck(:id))
      end
    end
  end
  def show?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) } ||
      @record.user_id != @user.id     
  end

  def index?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end

  def edit?
    show?
  end

  def update?
    show?
  end

  def create?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end

  def destroy?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end

  def new?
    [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
  end
end