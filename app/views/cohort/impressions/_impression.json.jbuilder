json.extract! impression, :id, :author_id, :subject_id, :content, :emoji, :created_at, :updated_at
json.url impression_url(impression, format: :json)
