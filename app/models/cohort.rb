# == Schema Information
#
# Table name: cohorts
#
#  id                   :uuid             not null, primary key
#  generation           :integer          not null
#  name                 :string
#  number               :integer          not null
#  piazza_course_number :string
#  year                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Cohort < ApplicationRecord
  include Adminable

  has_many :enrollments, dependent: :destroy
  has_many :piazza_activity_downloads, dependent: :destroy

  has_many :users, through: :enrollments, source: :user

  validates :year, presence: true
  validates :generation, presence: true
  validates :number,
    presence: true,
    uniqueness: {scope: ["generation", "year"]}

  scope :default_order, -> { order(:year, :generation, :number) }

  def to_s
    "[#{code}] #{name}"
  end

  def code
    "#{year}-#{generation}.#{number}"
  end
end
