class ImpressionPolicy < ApplicationPolicy

    def index?
      [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end
    
    def show?
      [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end
    
    def create?
      [:admin, :instructor, :ta].any? { |role| @user.has_role?(role) }
    end
    
    def new?
      create?
    end
    
    def update?
      edit?
    end
    
    def edit?
      @user.has_role?(:admin) || @record.author_id == @user.id  
    end
    
    def destroy?
      @user.has_role?(:admin)
    end

end
