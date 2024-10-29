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
  include Ransackable

  belongs_to :user
  belongs_to :cohort
  belongs_to :company
  belongs_to :job_description

  scope :default_order, -> { order(start_date: :desc) }
end


# TODO: discuss Pundit policies for placements, e.g., who within DPI should and shouldn't be able to see headshots/salary, etc.