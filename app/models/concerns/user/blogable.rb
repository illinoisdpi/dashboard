module User::Blogable
  extend ActiveSupport::Concern

  included do
    scope :bloggers, -> { where.not(devto_username: nil) }
    has_many :devto_articles, class_name: "DevtoArticle", foreign_key: "author_id"
    before_save { self.devto_username = devto_username.downcase if devto_username.present? }
  end

  class_methods do
    def fetch_devto_articles
      User.bloggers.each do |u|
        u.fetch_devto_articles
        sleep(1) # hack fix for 429 status code
      end
    end
  end

  def fetch_devto_articles
    return unless devto_username.present?

    DevtoService.fetch_articles({ username: devto_username })&.each do |article|
      devto_article = devto_articles.find_or_initialize_by(devto_id: article["id"])
      devto_article.title = article["title"]
      devto_article.description = article["description"]
      devto_article.url = article["url"]
      devto_article.published_at = article["published_timestamp"]
      devto_article.save
    end
  end
end
