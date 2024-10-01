require 'rails_helper'

RSpec.describe "impressions/edit", type: :view do
  let(:impression) {
    Impression.create!(
      author: nil,
      subject: nil,
      content: "MyText",
      emoji: "MyText"
    )
  }

  before do
    assign(:impression, impression)
  end

  it "renders the edit impression form" do
    render

    assert_select "form[action=?][method=?]", impression_path(impression), "post" do
      assert_select "input[name=?]", "impression[author_id]"

      assert_select "input[name=?]", "impression[subject_id]"

      assert_select "textarea[name=?]", "impression[content]"

      assert_select "textarea[name=?]", "impression[emoji]"
    end
  end
end
