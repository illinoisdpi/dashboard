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
class JobDescription < ApplicationRecord
  include Ransackable
  belongs_to :company

  has_many :placements, dependent: :nullify
end
