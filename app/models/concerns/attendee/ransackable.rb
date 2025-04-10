module Attendee::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "attendance_id",
        "enrollment_id"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "attendance",
        "enrollment"
      ]
    end
  end
end
