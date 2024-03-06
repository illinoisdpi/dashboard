class CreateRfpIdeaSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :rfp_idea_submissions, id: :uuid do |t|
      t.string :title
      t.text :details
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps
    end
  end
end
