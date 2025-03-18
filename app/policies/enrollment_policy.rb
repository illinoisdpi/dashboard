class EnrollmentPolicy < ApplicationPolicy
  def show?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def index?
    true
  end

  def edit?
    update?
  end

  def edit_role?
    user.admin? || user.instructor? || user.teaching_assistant?
  end

  def update?
    user.admin? || user.instructor? || user.teaching_assistant?
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

  def permitted_attributes
    if user.admin? || user.instructor?
      [
      :id, :role, :user_id, :cohort_id,
      user_attributes: [
        :id,
        :email,
        :salesforce_id,
        :discord_id,
        :discord_username,
        :github_username,
        :devto_username
        ]
      ]
    elsif user.teaching_assistant?
      [
        user_attributes: [
          :id,
          :salesforce_id,
          :discord_id,
          :discord_username,
          :github_username,
          :devto_username
          ]
        ]
    else
      []
    end
  end
end
