class EnrollmentPolicy < ApplicationPolicy
  def show?
    user.admin? || user.instructor? || user.teaching_assistant? || record.user_id == user.id
  end

  def index?
    true
  end

  def edit?
    user.admin? || user.instructor?
  end

  def update?
    show?
  end

  def create?
    user.admin? || user.instructor?
  end

  def destroy?
    user.admin? || user.instructor?
  end

  def new?
    user.admin? || user.instructor?
  end

  def overview?
    true
  end

  def view_rating?
    user.admin? || user.instructor?
  end
  
  def snapshot?
    true
  end
end
