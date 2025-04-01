# == Schema Information
#
# Table name: attendees
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  attendance_id :uuid             not null
#  enrollment_id :uuid             not null
#
# Indexes
#
#  index_attendees_on_attendance_id                    (attendance_id)
#  index_attendees_on_attendance_id_and_enrollment_id  (attendance_id,enrollment_id) UNIQUE
#  index_attendees_on_enrollment_id                    (enrollment_id)
#
# Foreign Keys
#
#  fk_rails_...  (attendance_id => attendances.id)
#  fk_rails_...  (enrollment_id => enrollments.id)
#
class Attendee < ApplicationRecord
  attr_accessor :_destroy

  belongs_to :attendance, counter_cache: true
  belongs_to :enrollment

  has_one :cohort, through: :attendance

  validates :enrollment_id, uniqueness: { scope: :attendance_id }

  after_create :increment_counter
  after_destroy :decrement_counter

  private

  def increment_counter
    if role == "student"
      attendance.increment!(:student_attendees_count)
    elsif role == "instructor"
      attendance.increment!(:instructor_attendees_count)
    end
    attendance.increment!(:attendees_count)
  end

  def decrement_counter
    if role == "student"
      attendance.decrement!(:student_attendees_count)
    elsif role == "instructor"
      attendance.decrement!(:instructor_attendees_count)
    end
    attendance.decrement!(:attendees_count)
  end
end
