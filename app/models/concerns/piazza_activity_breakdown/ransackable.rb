module PiazzaActivityBreakdown::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "answers",
        "created_at",
        "days_online",
        "edits_to_answers",
        "edits_to_posts",
        "emails",
        "enrollment_id",
        "followups",
        "good_question_given",
        "groups",
        "helpful_on_followups_given",
        "id",
        "instructor_good_answer",
        "instructor_good_comment",
        "instructor_good_question",
        "live_qa_upvotes",
        "name",
        "piazza_activity_download_id",
        "post_views",
        "posts",
        "replies_to_followups",
        "role",
        "student_good_question",
        "student_helpful_on_followups",
        "student_thanks_on_answer",
        "thanks_on_answers_given",
        "updated_at"
      ]
    end
  end
end
