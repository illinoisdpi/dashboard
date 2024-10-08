class UsersController < ApplicationController
  def search
    @users = User.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%").limit(10)
    authorize @users
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
