class FeedController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @articles = DevtoArticle.default_order.take(50)
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
