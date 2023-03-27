class AddIdFromCanvasToEnrollment < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :id_from_canvas, :string
    add_index :enrollments, :id_from_canvas, unique: true
  end
end
