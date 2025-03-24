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
  include Ransackable

  attr_accessor :_destroy

  belongs_to :attendance, counter_cache: true
  belongs_to :enrollment

  has_one :cohort, through: :attendance

  validates :enrollment_id, uniqueness: { scope: :attendance_id }
end
