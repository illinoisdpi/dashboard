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
#  piazza_activity_download_id  :uuid             not null
#
# Indexes
#
#  index_piazza_activity_breakdowns_on_enrollment_id                (enrollment_id)
#  index_piazza_activity_breakdowns_on_piazza_activity_download_id  (piazza_activity_download_id)
#
# Foreign Keys
#
#  fk_rails_...  (enrollment_id => enrollments.id)
#  fk_rails_...  (piazza_activity_download_id => piazza_activity_downloads.id)
#
require 'rails_helper'

RSpec.describe PiazzaActivityBreakdown, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
