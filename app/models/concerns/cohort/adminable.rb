module Cohort::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :name, :year, :month, :number, :piazza_course_number, :started_on
      end
    end
  end
end
