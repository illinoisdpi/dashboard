class CreateImpressions < ActiveRecord::Migration[7.0]
  def change
    create_table :impressions, id: :uuid do |t|
      t.references :author, null: false, foreign_key: {to_table: :users}, type: :uuid
      t.references :subject, null: false, foreign_key: {to_table: :enrollments}, type: :uuid
      t.text :content, null: false
      t.text :emoji, null: false

      t.timestamps
    end
  end
end
