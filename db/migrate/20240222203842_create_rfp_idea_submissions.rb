class CreateRfpIdeaSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :rfp_idea_submissions, id: :uuid do |t|
      t.string :contact_name
      t.string :email
      t.string :title
      t.text :details
      t.string :supporting_doc_filename

      t.timestamps
    end
  end
end
