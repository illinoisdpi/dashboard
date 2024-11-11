require "rails_helper"

RSpec.describe "cohorts/edit" do
  let(:cohort) {
    Cohort.create!(
      name: "MyString",
      year: 1,
      month: 1,
      number: 1,
      piazza_course_number: "MyString"
    )
  }

  before do
    assign(:cohort, cohort)
  end

  it "renders the edit cohort form" do
    render

    assert_select "form[action=?][method=?]", cohort_path(cohort), "post" do
      assert_select "input[name=?]", "cohort[name]"

      assert_select "input[name=?]", "cohort[year]"

      assert_select "input[name=?]", "cohort[month]"

      assert_select "input[name=?]", "cohort[number]"

      assert_select "input[name=?]", "cohort[piazza_course_number]"
    end
  end
end
