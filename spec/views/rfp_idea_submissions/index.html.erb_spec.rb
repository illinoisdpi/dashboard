require 'rails_helper'

RSpec.describe "rfp_idea_submissions/index", type: :view do
  before(:each) do
    assign(:rfp_idea_submissions, [
      RfpIdeaSubmission.create!(
        contact_name: "Contact Name",
        email: "Email",
        title: "Title",
        details: "MyText",
        supporting_doc_filename: "Supporting Doc Filename"
      ),
      RfpIdeaSubmission.create!(
        contact_name: "Contact Name",
        email: "Email",
        title: "Title",
        details: "MyText",
        supporting_doc_filename: "Supporting Doc Filename"
      )
    ])
  end

  it "renders a list of rfp_idea_submissions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Contact Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Supporting Doc Filename".to_s), count: 2
  end
end
