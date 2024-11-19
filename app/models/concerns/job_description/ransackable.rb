module JobDescription::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "title",
        "role_category",
        "description"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "user",
        "company",
        "placement"
      ]
    end
  end
end
