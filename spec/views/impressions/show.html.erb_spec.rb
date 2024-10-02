require 'rails_helper'

RSpec.describe "impressions/show", type: :view do
  before do
    assign(:impression, Impression.create!(
      author: nil,
      subject: nil,
      content: "MyText",
      emoji: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
