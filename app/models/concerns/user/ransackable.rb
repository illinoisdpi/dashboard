module User::Ransackable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [
        "canvas_full",
        "devto_username",
        "first_name",
        "last_name",
        "middle_name",
        "piazza_full"
      ]
    end

    def ransackable_associations(auth_object = nil)
      [
        "user"
      ]
    end
  end
end
