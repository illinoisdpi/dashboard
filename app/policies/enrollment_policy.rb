class EnrollmentPolicy < ApplicationPolicy
  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def index?
    true
  end

  def edit?
    user.admin? || user.instructor? || record.user == user
  end

  def edit_role?
    user.admin? || user.instructor?
  end

  def edit_user?
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
    # TODO: changing how we calculate endorsement in issue #214
    # Only allow admins/instructors to view rating until 214 is completed
    # || (record.is_a?(Enrollment) && record.user == user)
  end

  def snapshot?
    true
  end
end
