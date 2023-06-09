class RemoveUniqueConstraintFromIdFromCanvasIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :enrollments, :id_from_canvas
    add_index :enrollments, :id_from_canvas, unique: false
  end
end
