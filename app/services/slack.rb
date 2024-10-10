require "net/http"
require "json"

class Slack
  def initialize(webhook_url:)
    @webhook_url = webhook_url
  end

  def send_message(text)
    uri = URI.parse(@webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request.body = { text: text }.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      puts "Message sent successfully!"
    else
      raise "Failed to send the message!"
    end
  end
end
