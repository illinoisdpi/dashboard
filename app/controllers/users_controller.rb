class UsersController < ApplicationController
  def search
    @users = User.search(params[:name]).limit(10)
    authorize @users
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
