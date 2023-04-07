# == Schema Information
#
# Table name: canvas_gradebook_snapshots
#
#  id            :uuid             not null, primary key
#  csv_filename  :string
#  downloaded_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cohort_id     :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_canvas_gradebook_snapshots_on_cohort_id  (cohort_id)
#  index_canvas_gradebook_snapshots_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe CanvasGradebookSnapshot do
  pending "add some examples to (or delete) #{__FILE__}"
end
