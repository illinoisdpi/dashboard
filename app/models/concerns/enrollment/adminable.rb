module Enrollment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :role, :id_from_canvas
      end
    end
  end
end
