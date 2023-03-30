class CreateCanvasSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :canvas_submissions, id: :uuid do |t|
      t.references :canvas_assignment, null: false, foreign_key: true, type: :uuid
      t.references :enrollment, null: false, foreign_key: true, type: :uuid
      t.float :points
      t.references :canvas_gradebook_snapshot, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
