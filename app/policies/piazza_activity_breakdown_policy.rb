class PiazzaActivityBreakdownPolicy < ApplicationPolicy
    attr_reader :user, :piazza_activity_breakdown

    def initialize(user, piazza_activity_breakdown)
        @user = user
        @piazza_activity_breakdown = piazza_activity_breakdown
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
