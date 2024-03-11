require 'rails_helper'

RSpec.describe "rfp_idea_submissions/edit", type: :view do
  let(:rfp_idea_submission) {
    RfpIdeaSubmission.create!(
      contact_name: "MyString",
      email: "MyString",
      title: "MyString",
      details: "MyText",
      supporting_doc_filename: "MyString"
    )
  }

  before(:each) do
    assign(:rfp_idea_submission, rfp_idea_submission)
  end

  it "renders the edit rfp_idea_submission form" do
    render

    assert_select "form[action=?][method=?]", rfp_idea_submission_path(rfp_idea_submission), "post" do

      assert_select "input[name=?]", "rfp_idea_submission[contact_name]"

      assert_select "input[name=?]", "rfp_idea_submission[email]"

      assert_select "input[name=?]", "rfp_idea_submission[title]"

      assert_select "textarea[name=?]", "rfp_idea_submission[details]"

      assert_select "input[name=?]", "rfp_idea_submission[supporting_doc_filename]"
    end
  end
end
