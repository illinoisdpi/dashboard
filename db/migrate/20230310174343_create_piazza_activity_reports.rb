class CreatePiazzaActivityReports < ActiveRecord::Migration[7.0]
  def change
    create_table :piazza_activity_reports, id: :uuid do |t|
      t.datetime :activity_from, null: false
      t.datetime :activity_until, null: false
      t.string :csv_filename
      t.references :cohort, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
