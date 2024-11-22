# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  canvas_full            :string
#  career_highlights      :text
#  devto_username         :string
#  discord_username       :string
#  education              :text
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  fun_fact               :text
#  github_username        :string
#  headshot               :string
#  languages              :text
#  last_name              :string
#  middle_name            :string
#  most_recent_role       :text
#  one_liner              :text
#  personal_website       :string
#  piazza_full            :string
#  quote                  :text
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  skills_and_projects    :text
#  strengths              :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  discord_id             :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_github_username       (github_username) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
