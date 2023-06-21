class EnrollmentPolicy < ApplicationPolicy
    attr_reader :user, :enrollment

    def initialize(user, enrollment)
        @user = user
        @enrollment = enrollment
    end

    def show?
        @enrollment.user_id != @user.id  ||
        [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end

    def index?
        show?
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