class EnrollmentPolicy < ApplicationPolicy
    attr_reader :user, :enrollment

    def initialize(user, enrollment)
        @user = user
        @enrollment = enrollment
    end
    def show?
        @enrollment.user_id != @user.id  ||
        [:admin, :instructor].any? { |role| @user.has_role?(role) }
    end
    def index?
        show?
    end
end