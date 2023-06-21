class CanvasGradebookSnapshotPolicy < ApplicationPolicy
    attr_reader :user, :canvas_gradebook_snapshot

    def initialize(user, canvas_gradebook_snapshot)
        @user = user
        @canvas_gradebook_snapshot = canvas_gradebook_snapshot
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
