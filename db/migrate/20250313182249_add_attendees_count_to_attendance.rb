class AddAttendeesCountToAttendance < ActiveRecord::Migration[7.0]
  def up
    add_column :attendances, :attendees_count, :integer, default: 0, null: false

    Attendance.reset_column_information
    Attendance.find_each do |attendance|
      Attendance.reset_counters(attendance.id, :attendees)
    end
  end

  def down
    remove_column :attendances, :attendees_count
  end
end
