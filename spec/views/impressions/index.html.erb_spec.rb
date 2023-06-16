require 'rails_helper'

RSpec.describe "impressions/index", type: :view do
  before(:each) do
    assign(:impressions, [
      Impression.create!(
        author: nil,
        subject: nil,
        content: "MyText",
        emoji: "MyText"
      ),
      Impression.create!(
        author: nil,
        subject: nil,
        content: "MyText",
        emoji: "MyText"
      )
    ])
  end

  it "renders a list of impressions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
