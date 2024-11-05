class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  before_action :authenticate_user!, :set_paper_trail_whodunnit
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :set_time_zone

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :headshot,
      :first_name,
      :last_name,
      :middle_name,
      :github_username,
      :languages,
      :personal_website,
      :quote,
      :skills_and_projects,
      :strengths,
      :fun_fact,
      :one_liner,
      :most_recent_role,
      :career_highlights,
      :education,
      enrollments_attributes: [ :id, :skills_development ]
    ])
  end

  def set_time_zone(&block)
    Time.use_zone("America/Chicago", &block)
  end
end
