class FetchDevtoArticlesJob < ApplicationJob
  queue_as :default

  def perform
    User.fetch_devto_articles
  end
end
