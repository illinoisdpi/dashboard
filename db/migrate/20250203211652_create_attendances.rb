class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances, id: :uuid do |t|
      t.text :title
      t.string :category
      t.references :roll_taker, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.references :cohort, null: :false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
