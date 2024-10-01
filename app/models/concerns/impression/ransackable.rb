module Impression::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "content",
        "created_at"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "subject"
      ]
    end

    def ransackable_scopes(auth_object = nil)
      %i[by_time_period]
    end
  end
end
