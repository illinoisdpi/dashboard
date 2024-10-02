class CreateDevtoArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :devto_articles, id: :uuid do |t|
      t.integer :devto_id
      t.string :title
      t.string :url
      t.datetime :published_at
      t.text :description
      t.references :author, null: false, foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
