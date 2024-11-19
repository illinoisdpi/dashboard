class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :logo
      t.text :about
      t.string :name
      t.string :website

      t.timestamps
    end
  end
end
