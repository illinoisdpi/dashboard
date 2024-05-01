module Impression::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      []
    end

    def ransackable_associations(auth_object = nil)
      [
        "subject"
      ]
    end
  end
end
