# == Schema Information
#
# Table name: canvas_submissions
#
#  id                           :uuid             not null, primary key
#  points                       :float
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  canvas_assignment_id         :uuid             not null
#  canvas_gradebook_snapshot_id :uuid             not null
#  enrollment_id                :uuid             not null
#
# Indexes
#
#  index_canvas_submissions_on_canvas_assignment_id          (canvas_assignment_id)
#  index_canvas_submissions_on_canvas_gradebook_snapshot_id  (canvas_gradebook_snapshot_id)
#  index_canvas_submissions_on_enrollment_id                 (enrollment_id)
#
# Foreign Keys
#
#  fk_rails_...  (canvas_assignment_id => canvas_assignments.id)
#  fk_rails_...  (canvas_gradebook_snapshot_id => canvas_gradebook_snapshots.id)
#  fk_rails_...  (enrollment_id => enrollments.id)
#
require "rails_helper"

RSpec.describe CanvasSubmission do
  pending "add some examples to (or delete) #{__FILE__}"
end
