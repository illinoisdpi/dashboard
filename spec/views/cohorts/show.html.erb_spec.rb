require "rails_helper"

RSpec.describe "cohorts/show" do
  before do
    assign(:cohort, Cohort.create!(
      name: "Name",
      year: 2,
      generation: 3,
      number: 4,
      piazza_course_number: "Piazza Course Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Piazza Course Number/)
  end
end
