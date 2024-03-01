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
require 'rails_helper'

RSpec.describe RfpIdeaSubmission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
