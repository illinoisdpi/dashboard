class FetchDevtoArticlesJob < ApplicationJob
  queue_as :news

  def perform
    User.fetch_devto_articles
  end
end
