class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  
  before_action :authenticate_user!, :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :set_time_zone

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:headshot])
  end

  def set_time_zone(&block)
    Time.use_zone("America/Chicago", &block)
  end
end
