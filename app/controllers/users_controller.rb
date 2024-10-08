class UsersController < ApplicationController
  def search
    @users = User.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{params[:name]}%", "%#{params[:name]}%").limit(10)
    authorize @users # Ensure this line is present
    respond_to do |format|
      format.turbo_stream # Add this if you expect to respond with a Turbo Stream
      format.html # Add this if you have a corresponding HTML response
    end
  end
end
