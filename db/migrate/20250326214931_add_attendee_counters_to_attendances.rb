class AddAttendeeCountersToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_column :attendances, :student_attendees_count, :integer, default: 0, null: false
    add_column :attendances, :instructor_attendees_count, :integer, default: 0, null: false
  end
end
