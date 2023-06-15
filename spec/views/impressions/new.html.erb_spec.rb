require 'rails_helper'

RSpec.describe "impressions/new", type: :view do
  before(:each) do
    assign(:impression, Impression.new(
      author: nil,
      subject: nil,
      content: "MyText",
      emoji: "MyText"
    ))
  end

  it "renders new impression form" do
    render

    assert_select "form[action=?][method=?]", impressions_path, "post" do

      assert_select "input[name=?]", "impression[author_id]"

      assert_select "input[name=?]", "impression[subject_id]"

      assert_select "textarea[name=?]", "impression[content]"

      assert_select "textarea[name=?]", "impression[emoji]"
    end
  end
end
