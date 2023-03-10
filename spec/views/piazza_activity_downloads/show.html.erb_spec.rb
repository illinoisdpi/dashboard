require 'rails_helper'

RSpec.describe "piazza_activity_downloads/show", type: :view do
  before(:each) do
    assign(:piazza_activity_download, PiazzaActivityDownload.create!(
      cohort: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
