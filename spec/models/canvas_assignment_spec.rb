# == Schema Information
#
# Table name: canvas_assignments
#
#  id              :uuid             not null, primary key
#  authentication  :integer
#  css             :integer
#  databases       :integer
#  domain_modeling :integer
#  excluded        :boolean          default(FALSE)
#  html            :integer
#  id_from_canvas  :string
#  javascript      :integer
#  name            :string
#  points_possible :integer
#  position        :integer
#  rails           :integer
#  ruby            :integer
#  weight          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cohort_id       :uuid             not null
#
# Indexes
#
#  index_canvas_assignments_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
require "rails_helper"

RSpec.describe CanvasAssignment do
  pending "add some examples to (or delete) #{__FILE__}"
end
