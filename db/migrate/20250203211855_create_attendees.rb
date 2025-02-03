class CreateAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :attendees, id: :uuid do |t|
      t.references :attendance, null: false, foreign_key: true, type: :uuid
      t.references :enrollment, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
