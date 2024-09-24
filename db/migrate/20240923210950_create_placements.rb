class CreatePlacements < ActiveRecord::Migration[7.0]
  def change
    create_table :placements, id: :uuid do |t|
      t.date :start_date
      t.date :end_date
      t.uuid :cohort_id
      t.uuid :job_description_id
      t.uuid :user_id
      t.uuid :company_id
      t.string :salary

      t.timestamps
    end
  end
end
