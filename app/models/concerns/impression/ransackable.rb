module Impression::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "content",
        "author_first_name_or_author_last_name_cont",
        "subject_first_name_or_subject_last_name_cont"
      ]
    end

    def ransackable_associations(auth_object = nil)
      ["author", "subject"]
    end
  end
end
