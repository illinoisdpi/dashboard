# == Schema Information
#
# Table name: piazza_activity_reports
#
#  id             :uuid             not null, primary key
#  activity_from  :datetime         not null
#  activity_until :datetime         not null
#  csv_filename   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cohort_id      :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_piazza_activity_reports_on_cohort_id  (cohort_id)
#  index_piazza_activity_reports_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
class PiazzaActivityReport < ApplicationRecord
  include Csvable

  has_paper_trail skip: [:created_at, :updated_at]

  belongs_to :cohort
  belongs_to :user

  has_many :piazza_activity_breakdowns, dependent: :destroy

  validates :activity_from, presence: true
  validates :activity_until,
    presence: true,
    uniqueness: {scope: [:activity_from, :cohort]}

  scope :default_order, -> { order(activity_until: :desc) }

  def to_s
    "#{activity_from_humanized} to #{activity_until_humanized}"
  end

  def activity_from_humanized
    activity_from.strftime("%Y-%m-%d")
  end

  def activity_until_humanized
    activity_until.strftime("%Y-%m-%d")
  end
end
