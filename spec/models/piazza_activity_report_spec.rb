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
#
# Indexes
#
#  index_piazza_activity_reports_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
require "rails_helper"

RSpec.describe PiazzaActivityReport do
  pending "add some examples to (or delete) #{__FILE__}"
end
