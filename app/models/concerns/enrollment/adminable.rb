module Enrollment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :role
      end
    end
  end
end
    