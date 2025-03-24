module Attendance::Csvable
  extend ActiveSupport::Concern

  class_methods do
    def to_csv(attendances)
      headers = [
        "Occurred At",
        "Title",
        "Category",
        "Roll Taker",
        "Attendees"
      ]

      CSV.generate(headers: true) do |csv|
        csv << headers

        attendances.each do |attendance|
          csv << [
            attendance.occurred_at.strftime("%c"),
            attendance.title,
            attendance.category,
            attendance.roll_taker.name,
            attendance.attendees.map { |attendee| "#{attendee.enrollment.user.full_name}" }.join(", ")
          ]
        end
      end
    end
  end
end
