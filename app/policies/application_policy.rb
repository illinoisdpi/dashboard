# frozen_string_literal: true

class ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # rails_admin
  def dashboard?
    @user.has_role?(:admin) 
  end

  def export?
    @user.has_role?(:admin) 
  end
  
  def history?
    @user.has_role?(:admin)
  end
end
