json.extract! rfp_idea_submission, :id, :contact_name, :email, :title, :details, :phone_number, :created_at, :updated_at
json.url rfp_idea_submission_url(rfp_idea_submission, format: :json)
