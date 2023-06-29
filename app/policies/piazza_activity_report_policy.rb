class PiazzaActivityReportPolicy < ApplicationPolicy
  def index?
    admin? || instructor? || teaching_assistant?
  end
  
  def show?
    admin? || instructor? || teaching_assistant?
  end
  
  def create?
    admin? || instructor? || teaching_assistant?
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
