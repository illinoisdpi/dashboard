require "rails_helper"

RSpec.describe "piazza_activity_reports/edit" do
  let(:piazza_activity_report) {
    PiazzaActivityReport.create!(
      cohort: nil
    )
  }

  before do
    assign(:piazza_activity_report, piazza_activity_report)
  end

  it "renders the edit piazza_activity_report form" do
    render

    assert_select "form[action=?][method=?]", piazza_activity_report_path(piazza_activity_report), "post" do
      assert_select "input[name=?]", "piazza_activity_report[cohort_id]"
    end
  end
end
