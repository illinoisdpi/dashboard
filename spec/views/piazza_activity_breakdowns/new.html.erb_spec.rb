require "rails_helper"

RSpec.describe "piazza_activity_breakdowns/new" do
  before do
    assign(:piazza_activity_breakdown, PiazzaActivityBreakdown.new(
      enrollment: nil,
      emails: "MyString",
      role: "MyString",
      groups: "MyString",
      days_online: 1,
      posts: 1,
      edits_to_posts: 1,
      answers: 1,
      edits_to_answers: 1,
      followups: 1,
      replies_to_followups: 1,
      instructor_good_question: 1,
      instructor_good_answer: 1,
      instructor_good_comment: 1,
      student_good_question: 1,
      student_thanks_on_answer: 1,
      student_helpful_on_followups: 1,
      good_question_given: 1,
      thanks_on_answers_given: 1,
      helpful_on_followups_given: 1,
      post_views: 1,
      live_qa_upvotes: 1,
      piazza_activity_download: nil
    ))
  end

  it "renders new piazza_activity_breakdown form" do
    render

    assert_select "form[action=?][method=?]", piazza_activity_breakdowns_path, "post" do
      assert_select "input[name=?]", "piazza_activity_breakdown[enrollment_id]"

      assert_select "input[name=?]", "piazza_activity_breakdown[emails]"

      assert_select "input[name=?]", "piazza_activity_breakdown[role]"

      assert_select "input[name=?]", "piazza_activity_breakdown[groups]"

      assert_select "input[name=?]", "piazza_activity_breakdown[days_online]"

      assert_select "input[name=?]", "piazza_activity_breakdown[posts]"

      assert_select "input[name=?]", "piazza_activity_breakdown[edits_to_posts]"

      assert_select "input[name=?]", "piazza_activity_breakdown[answers]"

      assert_select "input[name=?]", "piazza_activity_breakdown[edits_to_answers]"

      assert_select "input[name=?]", "piazza_activity_breakdown[followups]"

      assert_select "input[name=?]", "piazza_activity_breakdown[replies_to_followups]"

      assert_select "input[name=?]", "piazza_activity_breakdown[instructor_good_question]"

      assert_select "input[name=?]", "piazza_activity_breakdown[instructor_good_answer]"

      assert_select "input[name=?]", "piazza_activity_breakdown[instructor_good_comment]"

      assert_select "input[name=?]", "piazza_activity_breakdown[student_good_question]"

      assert_select "input[name=?]", "piazza_activity_breakdown[student_thanks_on_answer]"

      assert_select "input[name=?]", "piazza_activity_breakdown[student_helpful_on_followups]"

      assert_select "input[name=?]", "piazza_activity_breakdown[good_question_given]"

      assert_select "input[name=?]", "piazza_activity_breakdown[thanks_on_answers_given]"

      assert_select "input[name=?]", "piazza_activity_breakdown[helpful_on_followups_given]"

      assert_select "input[name=?]", "piazza_activity_breakdown[post_views]"

      assert_select "input[name=?]", "piazza_activity_breakdown[live_qa_upvotes]"

      assert_select "input[name=?]", "piazza_activity_breakdown[piazza_activity_download_id]"
    end
  end
end
