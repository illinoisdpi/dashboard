require "rails_helper"

RSpec.describe "enrollments/index" do
  before do
    assign(:enrollments, [
      Enrollment.create!(
        role: "Role",
        user: nil,
        cohort: nil
      ),
      Enrollment.create!(
        role: "Role",
        user: nil,
        cohort: nil
      )
    ])
  end

  it "renders a list of enrollments" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Role".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
