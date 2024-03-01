class RemoveSupportingDocFilenameFromRfpIdeaSubmissions < ActiveRecord::Migration[7.0]
  def change
    remove_column :rfp_idea_submissions, :supporting_doc_filename 
  end
end
