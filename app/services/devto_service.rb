class DevtoService
  BASE_URL =  "https://dev.to/api"

  def self.fetch_articles(params)
    articles_url = "#{BASE_URL}/articles?#{params.to_query}"
    response = HTTParty.get(articles_url)
    return response if response.success?

    puts "Failed to fetch articles for username #{params.dig(:username)}}. Response code: #{response.code}"
  end
end
