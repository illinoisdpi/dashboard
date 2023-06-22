class EnrollmentPolicy < ApplicationPolicy

    def show?
        @record.user_id != @user.id  ||
          [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
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