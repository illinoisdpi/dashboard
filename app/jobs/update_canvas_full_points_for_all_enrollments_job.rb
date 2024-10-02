class UpdateCanvasFullPointsForAllEnrollmentsJob < ApplicationJob
  queue_as :default

  def perform(canvas_gradebook_snapshot_id)
    canvas_gradebook_snapshot = CanvasGradebookSnapshot.find(canvas_gradebook_snapshot_id)

    canvas_gradebook_snapshot.enrollments.each do |enrollment|
      enrollment.update_column(:canvas_full_points, canvas_gradebook_snapshot.full_points?(enrollment))
    end
  end
end
