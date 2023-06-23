class FeedController < ApplicationController
  def index
    @articles = DevtoArticle.default_order
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
