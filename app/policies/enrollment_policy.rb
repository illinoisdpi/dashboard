class EnrollmentPolicy < ApplicationPolicy
  def show?
    admin? || instructor? || teaching_assistant? || record.user_id == user.id
  end

  def index?
    true
  end

  def edit?
    admin? || instructor?
  end

  def update?
    show?
  end

  def create?
    admin? || instructor?
  end

  def destroy?
    admin? || instructor?
  end

  def new?
    admin? || instructor?
  end

  def overview?
    true
  end

  def rating?
    admin? || instructor?
  end
  
  def snapshot?
    true
  end
end
