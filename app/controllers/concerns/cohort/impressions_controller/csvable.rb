module Cohort::ImpressionsController::Csvable
  extend ActiveSupport::Concern

  def export_to_csv(impressions)
    headers = [
      'ID',
      'Created At',
      'Updated At',
      'Content',
      'Emoji',
      'Author ID',
      'Author Email',
      'Author First Name',
      'Author Last Name',
      'Subject ID',
      'Subject Email',
      'Subject First Name',
      'Subject Last Name'
    ]

    csv_string = CSV.generate(headers: true) do |csv|
      csv << headers

      impressions.each do |impression|
        csv << [
          impression.id,
          impression.created_at,
          impression.updated_at,
          impression.content,
          impression.emoji,
          impression.author_id,
          impression.author.email,
          impression.author.first_name,
          impression.author.last_name,
          impression.subject_id,
          impression.subject.email,
          impression.subject.first_name,
          impression.subject.last_name
        ]
      end
    end

    send_data csv_string, filename: "cohort-#{@cohort.canvas_shortname}-impressions-#{Date.today}.csv"
  end
end
