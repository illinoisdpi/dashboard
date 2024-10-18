class NewsController < ApplicationController
  layout "news"
  skip_before_action :authenticate_user!
  before_action { authorize(:news) }

  def index
    if params[:search_type].present? && params[:query].present?
      search_field = params[:search_type]
      search_query = params[:query]
      @q = policy_scope(DevtoArticle).ransack(search_field => search_query)
    else
      @q = policy_scope(DevtoArticle).ransack(params[:q])
    end
  
    @articles = @q.result.includes(:author).default_order.page(params[:page])
  end
  

  def rss
    @articles = policy_scope(DevtoArticle).default_order.take(50)
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
