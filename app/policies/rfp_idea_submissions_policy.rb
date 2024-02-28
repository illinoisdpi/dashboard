class RfpIdeaSubmissionsPolicy < ApplicationPolicy
  def index?
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
    true
  end

  def update?
  end

  def destroy?
  end
end