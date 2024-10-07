require 'rails_helper'

RSpec.describe "rfp_idea_submissions/new", type: :view do
  before do
    assign(:rfp_idea_submission, RfpIdeaSubmission.new(
      contact_name: "MyString",
      email: "MyString",
      title: "MyString",
      details: "MyText",
      supporting_doc_filename: "MyString"
    ))
  end

  it "renders new rfp_idea_submission form" do
    render

    assert_select "form[action=?][method=?]", rfp_idea_submissions_path, "post" do
      assert_select "input[name=?]", "rfp_idea_submission[contact_name]"

      assert_select "input[name=?]", "rfp_idea_submission[email]"

      assert_select "input[name=?]", "rfp_idea_submission[title]"

      assert_select "textarea[name=?]", "rfp_idea_submission[details]"

      assert_select "input[name=?]", "rfp_idea_submission[supporting_doc_filename]"
    end
  end
end
