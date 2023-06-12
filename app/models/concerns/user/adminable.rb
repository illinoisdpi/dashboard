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
          :strengths,
          :fun_fact,
          :first_name,
          :middle_name,
          :last_name,
          :one_liner,
          :skills_and_projects
      end
    end
  end

  def name
    self.to_s
  end
end
