# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  piazza_full            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :enrollments, dependent: :destroy

  has_many :cohorts, through: :enrollments, source: :cohort
end
