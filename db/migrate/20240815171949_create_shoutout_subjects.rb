class CreateShoutoutSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :shoutout_subjects, id: :uuid do |t|
      t.references :shoutout, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
