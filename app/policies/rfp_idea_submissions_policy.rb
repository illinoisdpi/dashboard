class RfpIdeaSubmissionsPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end
  
  def create?
    true
  end
  
  def edit?
  end

  def update?
  end

  def destroy?
  end
end