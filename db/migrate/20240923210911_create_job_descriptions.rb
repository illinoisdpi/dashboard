class CreateJobDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :job_descriptions, id: :uuid do |t|
      t.string :title
      t.text :description
      t.uuid :company_id
      t.string :role_category

      t.timestamps
    end
  end
end
