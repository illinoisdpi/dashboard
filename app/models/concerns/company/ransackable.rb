module Company::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "about",
        "name",
        "website"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "user",
        "job_description",
        "placement"
      ]
    end
  end
end
