require "rails_helper"

RSpec.describe "enrollments/edit" do
  let(:enrollment) {
    Enrollment.create!(
      role: "MyString",
      user: nil,
      cohort: nil
    )
  }

  before do
    assign(:enrollment, enrollment)
  end

  it "renders the edit enrollment form" do
    render

    assert_select "form[action=?][method=?]", enrollment_path(enrollment), "post" do
      assert_select "input[name=?]", "enrollment[role]"

      assert_select "input[name=?]", "enrollment[user_id]"

      assert_select "input[name=?]", "enrollment[cohort_id]"
    end
  end
end
