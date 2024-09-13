module Cohort::ImpressionsController::Csvable
  extend ActiveSupport::Concern

  def export_to_csv(impressions)
    headers = [
      'Created At',
      'Emoji',
      'Category',
      'Description',
      'Content',
      'Author First Name',
      'Author Last Name',
      'Subject First Name',
      'Subject Last Name',
      'URL'
    ]

    csv_string = CSV.generate(headers: true) do |csv|
      csv << headers

      impressions.each do |impression|
        csv << [
          impression.created_at.strftime("%c"),
          impression.emoji,
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

    send_data csv_string, filename: "cohort-#{@cohort.canvas_shortname}-impressions-#{Date.today}.csv"
  end
end
