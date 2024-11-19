class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    if params[:current_password].present?
      resource.update_with_password(params)
    else
      resource.update_without_password(params)
    end
  end
end
