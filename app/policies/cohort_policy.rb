class CohortPolicy < ApplicationPolicy
    attr_reader :user, :cohort

    def initialize(user, cohort)
        @user = user
        @cohort = cohort
    end

    def show?
        # The current user is not enrolled in this cohort
        # OR the current user is an admin or instructor:
        @cohort.enrollments.where(user_id: @user.id).empty? ||
           [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
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