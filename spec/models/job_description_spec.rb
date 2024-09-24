# == Schema Information
#
# Table name: job_descriptions
#
#  id            :uuid             not null, primary key
#  description   :text
#  role_category :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company_id    :uuid
#
require 'rails_helper'

RSpec.describe JobDescription, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
