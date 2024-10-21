class NewsController < ApplicationController
  layout "news"
  skip_before_action :authenticate_user!
  before_action { authorize(:news) }

  def index
    @q = policy_scope(DevtoArticle).page(params[:page]).ransack(params[:q])
    @articles = @q.result.includes(:author).default_order
  end

  def rss
    @articles = policy_scope(DevtoArticle).default_order.take(50)
    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
