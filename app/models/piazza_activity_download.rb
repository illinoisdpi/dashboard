# == Schema Information
#
# Table name: piazza_activity_downloads
#
#  id             :uuid             not null, primary key
#  activity_from  :datetime         not null
#  activity_until :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cohort_id      :uuid             not null
#
# Indexes
#
#  index_piazza_activity_downloads_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
class PiazzaActivityDownload < ApplicationRecord
  belongs_to :cohort
  
  has_many  :piazza_activity_breakdowns, dependent: :destroy

  validates :activity_from, presence: true
  validates :activity_until, presence: true
end
