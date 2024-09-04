class RfpIdeaSubmissionPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def update?
    user.admin?
  end

  def new?
    true
  end

  def create?
    true
  end
end
