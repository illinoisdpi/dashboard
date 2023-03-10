require "rails_helper"

RSpec.describe "piazza_activity_downloads/new" do
  before do
    assign(:piazza_activity_download, PiazzaActivityDownload.new(
      cohort: nil
    ))
  end

  it "renders new piazza_activity_download form" do
    render

    assert_select "form[action=?][method=?]", piazza_activity_downloads_path, "post" do
      assert_select "input[name=?]", "piazza_activity_download[cohort_id]"
    end
  end
end
