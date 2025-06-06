module CanvasAssignment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :authentication, :css, :databases, :domain_modeling, :excluded, :html, :javascript, :rails, :ruby, :weight, :position, :points_possible
      end
    end
  end
end
