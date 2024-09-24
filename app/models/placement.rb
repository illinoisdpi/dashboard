# == Schema Information
#
# Table name: placements
#
#  id                 :uuid             not null, primary key
#  end_date           :date
#  salary             :string
#  start_date         :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cohort_id          :uuid
#  company_id         :uuid
#  job_description_id :uuid
#  user_id            :uuid
#
class Placement < ApplicationRecord
  belongs_to :user

  belongs_to :company

  belongs_to :job_description

  belongs_to :cohort
end
