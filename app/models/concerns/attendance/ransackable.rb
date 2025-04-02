module Attendance::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "category",
        "title",
        "occurred_at",
        "cohort_id"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "cohort",
        "attendees",
        "enrollments"
      ]
    end

    def ransackable_scopes(auth_object = nil)
      %i[by_time_period]
    end
  end
end
