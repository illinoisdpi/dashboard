require 'rails_helper'

RSpec.describe "piazza_activity_downloads/index", type: :view do
  before(:each) do
    assign(:piazza_activity_downloads, [
      PiazzaActivityDownload.create!(
        cohort: nil
      ),
      PiazzaActivityDownload.create!(
        cohort: nil
      )
    ])
  end

  it "renders a list of piazza_activity_downloads" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
