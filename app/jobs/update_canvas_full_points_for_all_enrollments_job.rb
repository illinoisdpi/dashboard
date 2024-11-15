class UpdateCanvasFullPointsForAllEnrollmentsJob < ApplicationJob
  queue_as :default

  def perform(canvas_gradebook_snapshot)
    canvas_gradebook_snapshot.update_canvas_full_points
  end
end
