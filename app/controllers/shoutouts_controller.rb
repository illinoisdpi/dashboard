class ShoutoutsController < ApplicationController
  before_action { authorize(Shoutout) }

  def index
    @shoutouts = policy_scope(Shoutout)
  end

  def create
  end
end
