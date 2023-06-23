class CohortPolicy < ApplicationPolicy

    def show?
        # The current user is not enrolled in this cohort
        # OR the current user is an admin or instructor:
        [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) } ||
          @record.enrollments.where(user_id: @user.id).empty?
           
    end

    def index?
        true
    end

    def edit?
        show?
    end

    def update?
        show?
    end

    def create?
        [:admin].any? { |role| @user.has_role?(role) }
    end

    def destroy?
        [:admin].any? { |role| @user.has_role?(role) }
    end

    def new?
        [:admin].any? { |role| @user.has_role?(role) }
    end
end