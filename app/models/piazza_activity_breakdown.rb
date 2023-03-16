# == Schema Information
#
# Table name: piazza_activity_breakdowns
#
#  id                           :uuid             not null, primary key
#  answers                      :integer          not null
#  days_online                  :integer          not null
#  edits_to_answers             :integer          not null
#  edits_to_posts               :integer          not null
#  emails                       :string           not null
#  followups                    :integer          not null
#  good_question_given          :integer          not null
#  groups                       :string
#  helpful_on_followups_given   :integer          not null
#  instructor_good_answer       :integer          not null
#  instructor_good_comment      :integer          not null
#  instructor_good_question     :integer          not null
#  live_qa_upvotes              :integer          not null
#  name                         :string
#  post_views                   :integer          not null
#  posts                        :integer          not null
#  replies_to_followups         :integer          not null
#  role                         :string           not null
#  student_good_question        :integer          not null
#  student_helpful_on_followups :integer          not null
#  student_thanks_on_answer     :integer          not null
#  thanks_on_answers_given      :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  enrollment_id                :uuid             not null
#  piazza_activity_report_id    :uuid             not null
#
# Indexes
#
#  index_piazza_activity_breakdowns_on_enrollment_id  (enrollment_id)
#  index_piazza_activity_breakdowns_on_reports_id     (piazza_activity_report_id)
#
# Foreign Keys
#
#  fk_rails_...  (enrollment_id => enrollments.id)
#  fk_rails_...  (piazza_activity_report_id => piazza_activity_reports.id)
#
class PiazzaActivityBreakdown < ApplicationRecord
  belongs_to :enrollment
  belongs_to :piazza_activity_report
  has_one :user, through: :enrollment

  # define which attributes can be available to ransack
  def self.ransackable_attributes(auth_object = nil)
    ["answers", "created_at", "days_online", "edits_to_answers", "edits_to_posts", "emails", "enrollment_id", "followups", "good_question_given", "groups", "helpful_on_followups_given", "id", "instructor_good_answer", "instructor_good_comment", "instructor_good_question", "live_qa_upvotes", "name", "piazza_activity_download_id", "post_views", "posts", "replies_to_followups", "role", "student_good_question", "student_helpful_on_followups", "student_thanks_on_answer", "thanks_on_answers_given", "updated_at"]
  end
end
