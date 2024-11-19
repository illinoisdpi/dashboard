class CreatePlacements < ActiveRecord::Migration[7.0]
  def change
    create_table :placements, id: :uuid do |t|
      t.date :start_date
      t.date :end_date
      t.references :cohort, type: :uuid, foreign_key: true, null: false
      t.references :job_description, type: :uuid, foreign_key: true, null: false
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :company, type: :uuid, foreign_key: true, null: false
      t.string :salary
      t.boolean :by_dpi, default: true, null: false

      t.timestamps
    end
  end
end
