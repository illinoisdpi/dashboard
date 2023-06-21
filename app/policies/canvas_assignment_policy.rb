class CanvasAssignmentPolicy < ApplicationPolicy
    attr_reader :user, :canvas_assignment

    def initialize(user, canvas_assignment)
        @user = user
        @canvas_assignment = canvas_assignment
    end

    def index?
        [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end
    
    def show?
        [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end
    
    def create?
        [:admin].any? { |role| @user.has_role?(role) }
    end
    
    def new?
        create?
    end
    
    def update?
        create?
    end
    
    def edit?
        create?
    end
    
    def destroy?
        create?
    end
end
