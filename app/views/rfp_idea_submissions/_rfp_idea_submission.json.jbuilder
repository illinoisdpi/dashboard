json.extract! rfp_idea_submission, :id, :contact_name, :contact_email, :title, :details, :contact_phone, :created_at, :updated_at
json.url rfp_idea_submission_url(rfp_idea_submission, format: :json)
