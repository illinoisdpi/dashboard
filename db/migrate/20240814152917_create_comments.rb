class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.uuid :impression_id, null: false, foreign_key: true
      t.uuid :user_id, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end

    add_index :comments, :impression_id
    add_index :comments, :user_id
  end
end
