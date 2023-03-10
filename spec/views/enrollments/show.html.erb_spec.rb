require "rails_helper"

RSpec.describe "enrollments/show" do
  before do
    assign(:enrollment, Enrollment.create!(
      role: "Role",
      user: nil,
      cohort: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Role/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
