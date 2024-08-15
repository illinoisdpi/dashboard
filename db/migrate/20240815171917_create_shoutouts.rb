class CreateShoutouts < ActiveRecord::Migration[7.0]
  def change
    create_table :shoutouts, id: :uuid do |t|
      t.integer :author_id
      t.text :content
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
