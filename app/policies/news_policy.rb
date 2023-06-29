class NewsPolicy < ApplicationPolicy
  def index?
    true
  end

  def rss?
    true
  end
end