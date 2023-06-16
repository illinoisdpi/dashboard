module Impression::Slackable
  extend ActiveSupport::Concern

  included do
    # TODO: move to job
    after_create_commit :send_slack_message
  end

  def send_slack_message
    webhook_url = Rails.application.credentials.dig(:slack, :impressions_webhook_url)
    # TODO: call in job so we don't need this
    return unless webhook_url.present?

    url = Rails.application.routes.url_helpers.url_for(self)
    Slack.new(webhook_url:).send_message("#{summary} #{url}")
  end
end
