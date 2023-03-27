# == Schema Information
#
# Table name: enrollments
#
#  id             :uuid             not null, primary key
#  id_from_canvas :string
#  role           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cohort_id      :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_enrollments_on_cohort_id       (cohort_id)
#  index_enrollments_on_id_from_canvas  (id_from_canvas) UNIQUE
#  index_enrollments_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Enrollment do
  pending "add some examples to (or delete) #{__FILE__}"
end
