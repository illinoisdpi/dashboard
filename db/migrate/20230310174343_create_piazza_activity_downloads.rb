class CreatePiazzaActivityDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :piazza_activity_downloads, id: :uuid do |t|
      t.datetime :activity_from, null: false
      t.datetime :activity_until, null: false
      t.references :cohort, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
