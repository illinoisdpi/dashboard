class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  around_action :set_time_zone

  private

  def set_time_zone(&block)
    Time.use_zone("America/Chicago", &block)
  end
end
