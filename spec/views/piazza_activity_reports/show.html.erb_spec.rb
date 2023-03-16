require "rails_helper"

RSpec.describe "piazza_activity_reports/show" do
  before do
    assign(:piazza_activity_report, PiazzaActivityReport.create!(
      cohort: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
