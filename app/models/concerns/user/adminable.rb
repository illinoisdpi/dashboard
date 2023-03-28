module User::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :email, :github_username, :password, :password_confirmation, :roles
      end
    end
  end
end
