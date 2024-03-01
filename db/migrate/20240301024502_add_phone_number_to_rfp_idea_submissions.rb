class AddPhoneNumberToRfpIdeaSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :rfp_idea_submissions, :phone_number, :string
  end
end
