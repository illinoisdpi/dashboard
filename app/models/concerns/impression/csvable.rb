module Impression::Csvable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv(impressions)
      headers = [
        "Created At",
        "Private",
        "Sentiment",
        "Category",
        "Description",
        "Content",
        "Author First Name",
        "Author Last Name",
        "Subject First Name",
        "Subject Last Name",
        "URL"
      ]

      CSV.generate(headers: true) do |csv|
        csv << headers

        impressions.each do |impression|
          csv << [
            impression.created_at.strftime("%c"),
            impression.staff_only,
            impression.emoji_sentiment,
            impression.emoji_category,
            impression.emoji_description,
            impression.content,
            impression.author.first_name,
            impression.author.last_name,
            impression.subject.first_name,
            impression.subject.last_name,
            Rails.application.routes.url_helpers.url_for(impression)
          ]
        end
      end
    end
  end
end
