class CreateImpressionComments < ActiveRecord::Migration[7.0]
  def change
    create_table :impression_comments, id: :uuid do |t|
      t.uuid :impression_id, null: false, foreign_key: true
      t.uuid :user_id, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps
    end

    add_index :impression_comments, :impression_id
    add_index :impression_comments, :user_id
  end
end
