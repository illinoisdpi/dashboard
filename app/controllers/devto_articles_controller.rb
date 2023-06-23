class DevtoArticlesController < ApplicationController
  def index
    @breadcrumbs = [
      {content: "Dashboard", href: root_path},
      {content: "Articles", href: devto_articles_path}
    ]
    # TODO: add pagination / searching / sorting
    @articles = DevtoArticle.default_order
  end
end
