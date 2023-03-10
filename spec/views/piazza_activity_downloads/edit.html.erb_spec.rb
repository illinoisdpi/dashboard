require 'rails_helper'

RSpec.describe "piazza_activity_downloads/edit", type: :view do
  let(:piazza_activity_download) {
    PiazzaActivityDownload.create!(
      cohort: nil
    )
  }

  before(:each) do
    assign(:piazza_activity_download, piazza_activity_download)
  end

  it "renders the edit piazza_activity_download form" do
    render

    assert_select "form[action=?][method=?]", piazza_activity_download_path(piazza_activity_download), "post" do

      assert_select "input[name=?]", "piazza_activity_download[cohort_id]"
    end
  end
end
