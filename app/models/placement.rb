# == Schema Information
#
# Table name: placements
#
#  id                 :uuid             not null, primary key
#  by_dpi             :boolean          default(TRUE), not null
#  end_date           :date
#  salary             :string
#  start_date         :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cohort_id          :uuid             not null
#  company_id         :uuid             not null
#  job_description_id :uuid             not null
#  user_id            :uuid             not null
#
# Indexes
#
#  index_placements_on_cohort_id           (cohort_id)
#  index_placements_on_company_id          (company_id)
#  index_placements_on_job_description_id  (job_description_id)
#  index_placements_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (job_description_id => job_descriptions.id)
#  fk_rails_...  (user_id => users.id)
#
class Placement < ApplicationRecord
  include Ransackable

  belongs_to :user
  belongs_to :cohort
  belongs_to :company
  belongs_to :job_description

  scope :default_order, -> { order(start_date: :desc) }
end
