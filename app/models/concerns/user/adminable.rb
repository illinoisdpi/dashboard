module User::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :email, :password, :password_confirmation, :roles
      end
    end
  end
end
  