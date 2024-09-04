# == Schema Information
#
# Table name: rfp_idea_submissions
#
#  id            :uuid             not null, primary key
#  contact_email :string
#  contact_name  :string
#  contact_phone :string
#  details       :text
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class RfpIdeaSubmission < ApplicationRecord
  validates :contact_name, presence: true
  validates :contact_email, presence: true
  validates :title, presence: true
  validates :details, presence: true
  # Send confirmation email to the submitter
  after_create_commit -> { RfpIdeaSubmissionsMailer.confirmation(self).deliver_now }
end
