class NewsController < ApplicationController
  layout "news"
  skip_before_action :authenticate_user!

  def index
    @q = DevtoArticle.page(params[:page]).ransack(params[:q])
    @articles = @q.result.includes(:author).default_order
  end

  def rss
    @articles = DevtoArticle.default_order.take(50)
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
