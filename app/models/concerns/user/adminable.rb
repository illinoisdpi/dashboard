module User::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      configure :discord_id do
        label "Discord Id"
      end

      edit do
        include_fields :education,
          :email,
          :github_username,
          :languages,
          :most_recent_role,
          :personal_website,
          :quote,
          :strengths,
          :fun_fact,
          :first_name,
          :middle_name,
          :last_name,
          :one_liner,
          :skills_and_projects,
          :career_highlights,
          :headshot,
          :devto_username,
          :canvas_full,
          :discord_id,
          :discord_username,
          :salesforce_id

        field :roles do
          visible do
            bindings[:controller].current_user.admin?
          end
        end

        password_fields = [ :password, :password_confirmation ]
        password_fields.each do |field_name|
          field field_name do
            visible do
              UserPolicy.new(bindings[:controller].current_user, bindings[:object]).change_password?
            end
          end
        end
      end
    end
  end

  def name
    to_s
  end
end
