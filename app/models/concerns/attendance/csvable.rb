module Attendance::Csvable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv(attendances)
      headers = [
        "Date",
        "Time",
        "Category",
        "Title",
        "Name",
        "Roll Taker"
      ]

      CSV.generate(headers: true) do |csv|
        csv << headers

        attendances.each do |attendance|
          if attendance.attendees.any?
            attendance.attendees.each do |attendee|
              csv << [
                attendance.occurred_at.strftime("%Y-%m-%d"),
                attendance.occurred_at.strftime("%H:%M"),
                attendance.category.titleize,
                attendance.title,
                attendee.enrollment.user.full_name,
                attendance.roll_taker.name
              ]
            end
          end
        end
      end
    end
  end
end
