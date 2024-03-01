# == Schema Information
#
# Table name: rfp_idea_submissions
#
#  id           :uuid             not null, primary key
#  contact_name :string
#  details      :text
#  email        :string
#  phone_number :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class RfpIdeaSubmission < ApplicationRecord
  validates :contact_name, presence: true
  validates :title, presence: true
  validates :email, presence: true
  validates :details, presence: true
end
