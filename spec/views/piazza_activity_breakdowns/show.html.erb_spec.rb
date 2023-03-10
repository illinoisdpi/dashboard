require 'rails_helper'

RSpec.describe "piazza_activity_breakdowns/show", type: :view do
  before(:each) do
    assign(:piazza_activity_breakdown, PiazzaActivityBreakdown.create!(
      enrollment: nil,
      emails: "Emails",
      role: "Role",
      groups: "Groups",
      days_online: 2,
      posts: 3,
      edits_to_posts: 4,
      answers: 5,
      edits_to_answers: 6,
      followups: 7,
      replies_to_followups: 8,
      instructor_good_question: 9,
      instructor_good_answer: 10,
      instructor_good_comment: 11,
      student_good_question: 12,
      student_thanks_on_answer: 13,
      student_helpful_on_followups: 14,
      good_question_given: 15,
      thanks_on_answers_given: 16,
      helpful_on_followups_given: 17,
      post_views: 18,
      live_qa_upvotes: 19,
      piazza_activity_download: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Emails/)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Groups/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/15/)
    expect(rendered).to match(/16/)
    expect(rendered).to match(/17/)
    expect(rendered).to match(/18/)
    expect(rendered).to match(/19/)
    expect(rendered).to match(//)
  end
end
