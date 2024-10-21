class UserPolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    edit?
  end

  def edit?
    user.admin? || user.instructor? || user.teaching_assistant? || (record.is_a?(User) && user == record)
  end

  def destroy?
    create?
  end

  def change_password?
    user.admin? || (record.is_a?(User) && user == record)
  end
# This is only in the context of creating an enrollment - might need to take another look at this in the future
  def search?
    user.admin? || user.instructor? || user.teaching_assistant?
  end
end
