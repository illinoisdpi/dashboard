class UsersController < ApplicationController
  def search_by_name
    @users = User.search_by_name(params[:name]).limit(10)
    authorize @users
    respond_to do |format|
      format.turbo_stream
    end
  end
end
