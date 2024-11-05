require "http"
require "json"

class DevtoService
  BASE_URL = "https://dev.to/api"

  def self.fetch_articles(params)
    articles_url = "#{BASE_URL}/articles?#{params.to_query}"
    response = HTTP.headers(Accept: "application/vnd.forem.api-v1+json").get(articles_url)

    if response.status.success?
      body = response.body.to_s
      JSON.parse(body)

    else
      Rails.logger.warn { "Failed to fetch articles for username #{params.dig(:username)}. Response code: #{response.status}" }
      nil
    end
  end
end
