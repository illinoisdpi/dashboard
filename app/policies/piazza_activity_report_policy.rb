class PiazzaActivityReportPolicy < ApplicationPolicy
    attr_reader :user, :piazza_activity_report

    def initialize(user, piazza_activity_report)
        @user = user
        @piazza_activity_report = piazza_activity_report
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
