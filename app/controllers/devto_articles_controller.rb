class DevtoArticlesController < ApplicationController
  def index
    @breadcrumbs = [
      {content: "Dashboard", href: root_path},
      {content: "Articles", href: devto_articles_path}
    ]
    # TODO: add pagination / sorting
    @q = DevtoArticle.ransack(params[:q])
    @articles = @q.result.includes(:author).default_order
  end
end
