class PopulateAttendeeCounters < ActiveRecord::Migration[7.0]
  disable_ddl_transaction! # Prevents long locks in production

  def up
    Attendance.find_each do |attendance|
      student_count = attendance.attendees.joins(:enrollment).where(enrollments: { role: "student" }).count
      instructor_count = attendance.attendees.joins(:enrollment).where(enrollments: { role: "instructor" }).count

      attendance.update_columns(
        student_attendees_count: student_count,
        instructor_attendees_count: instructor_count
      )
    end
  end

  def down
  end
end
