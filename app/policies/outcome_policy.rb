class OutcomePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def search?
    true
  end
end
