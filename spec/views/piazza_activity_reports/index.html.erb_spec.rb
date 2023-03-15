require "rails_helper"

RSpec.describe "piazza_activity_reports/index" do
  before do
    assign(:piazza_activity_reports, [
      PiazzaActivityReport.create!(
        cohort: nil
      ),
      PiazzaActivityReport.create!(
        cohort: nil
      )
    ])
  end

  it "renders a list of piazza_activity_reports" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
