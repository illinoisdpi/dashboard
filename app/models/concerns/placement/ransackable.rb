module Placement::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "end_date",
        "salary",
        "start_date"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "job_description",
        "user",
        "company"
      ]
    end
  end
end
