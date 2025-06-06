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
#  salesforce_id          :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_github_username       (github_username) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Adminable, Blogable, Ransackable, Roleable

  mount_uploader :headshot, HeadshotUploader

  has_paper_trail skip: [ :created_at, :updated_at ]

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable

  has_many :enrollments, dependent: :destroy
  has_many :cohorts, through: :enrollments, source: :cohort
  has_many :authored_impressions, class_name: "Impression", foreign_key: "author_id"
  has_many :impressions, through: :enrollments
  has_many :attendances, through: :enrollments

  accepts_nested_attributes_for :enrollments

  scope :default_order, -> { order(:first_name) }

  scope :search_by_name, ->(name) {
    where("CONCAT(first_name, ' ', last_name) ILIKE ?", "%#{name}%")
  }

  def to_s
    return full_name if full_name.present?

    canvas_full || piazza_full || email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name
    to_s
  end
end
