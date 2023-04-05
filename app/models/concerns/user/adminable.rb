module User::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :education,
          :email,
          :github_username,
          :languages,
          :most_recent_role,
          :password_confirmation,
          :password,
          :personal_website,
          :quote,
          :roles,
          :strengths
      end
    end
  end

  def name
    self.to_s
  end
end
