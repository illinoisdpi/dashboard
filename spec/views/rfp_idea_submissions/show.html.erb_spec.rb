require 'rails_helper'

RSpec.describe "rfp_idea_submissions/show", type: :view do
  before(:each) do
    assign(:rfp_idea_submission, RfpIdeaSubmission.create!(
      contact_name: "Contact Name",
      email: "Email",
      title: "Title",
      details: "MyText",
      supporting_doc_filename: "Supporting Doc Filename"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Supporting Doc Filename/)
  end
end
