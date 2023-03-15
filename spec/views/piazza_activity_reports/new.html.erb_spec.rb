require "rails_helper"

RSpec.describe "piazza_activity_reports/new" do
  before do
    assign(:piazza_activity_report, PiazzaActivityReport.new(
      cohort: nil
    ))
  end

  it "renders new piazza_activity_report form" do
    render

    assert_select "form[action=?][method=?]", piazza_activity_reports_path, "post" do
      assert_select "input[name=?]", "piazza_activity_report[cohort_id]"
    end
  end
end
