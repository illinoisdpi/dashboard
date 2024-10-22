# == Schema Information
#
# Table name: companies
#
#  id         :uuid             not null, primary key
#  about      :text
#  logo       :string
#  name       :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
  include Ransackable
  has_many :job_descriptions

  has_many :placements, dependent: :nullify
end
