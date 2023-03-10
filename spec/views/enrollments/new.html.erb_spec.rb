require "rails_helper"

RSpec.describe "enrollments/new" do
  before do
    assign(:enrollment, Enrollment.new(
      role: "MyString",
      user: nil,
      cohort: nil
    ))
  end

  it "renders new enrollment form" do
    render

    assert_select "form[action=?][method=?]", enrollments_path, "post" do
      assert_select "input[name=?]", "enrollment[role]"

      assert_select "input[name=?]", "enrollment[user_id]"

      assert_select "input[name=?]", "enrollment[cohort_id]"
    end
  end
end
