require "rails_helper"

RSpec.describe "piazza_activity_breakdowns/index" do
  before do
    assign(:piazza_activity_breakdowns, [
      PiazzaActivityBreakdown.create!(
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
        piazza_activity_report: nil
      ),
      PiazzaActivityBreakdown.create!(
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
        piazza_activity_report: nil
      )
    ])
  end

  it "renders a list of piazza_activity_breakdowns" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Emails".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Role".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Groups".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(6.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(7.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(8.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(9.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(10.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(11.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(12.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(13.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(14.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(15.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(16.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(17.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(18.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(19.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
