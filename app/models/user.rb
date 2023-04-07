# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  canvas_full            :string
#  education              :text
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  github_username        :string
#  languages              :text
#  most_recent_role       :text
#  personal_website       :string
#  piazza_full            :string
#  quote                  :text
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  strengths              :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_github_username       (github_username) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Adminable

  has_paper_trail skip: [:created_at, :updated_at]

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable

  has_many :enrollments, dependent: :destroy

  has_many :cohorts, through: :enrollments, source: :cohort

  def to_s
    canvas_full || piazza_full || email
  end

  def name
    to_s
  end
end
