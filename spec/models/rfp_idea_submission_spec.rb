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
require 'rails_helper'

RSpec.describe RfpIdeaSubmission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
