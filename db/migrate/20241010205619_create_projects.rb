class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name
      t.string :github_url
      t.string :url
      t.text :description
      t.string :image
      t.references :user, foreign_key: {to_table: :users}, type: :uuid

      t.timestamps
    end
  end
end
