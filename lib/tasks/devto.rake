namespace :devto do
  desc "Fetch user articles from devto"
  task fetch_articles: :environment do
    User.fetch_devto_articles
  end
end
