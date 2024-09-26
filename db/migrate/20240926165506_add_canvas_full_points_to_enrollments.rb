class AddCanvasFullPointsToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :canvas_full_points, :boolean, default: false, null: false
  end
end
