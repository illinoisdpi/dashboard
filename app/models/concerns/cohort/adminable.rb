module Cohort::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :name, :year, :generation, :number, :piazza_course_number
      end
    end
  end
end
