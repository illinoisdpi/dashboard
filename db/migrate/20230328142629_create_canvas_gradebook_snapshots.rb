class CreateCanvasGradebookSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :canvas_gradebook_snapshots, id: :uuid do |t|
      t.datetime :downloaded_at
      t.string :csv_filename
      t.references :cohort, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
