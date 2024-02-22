# == Schema Information
#
# Table name: rfp_idea_submissions
#
#  id                      :uuid             not null, primary key
#  contact_name            :string
#  details                 :text
#  email                   :string
#  supporting_doc_filename :string
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class RfpIdeaSubmission < ApplicationRecord
end
