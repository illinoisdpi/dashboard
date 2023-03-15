# == Schema Information
#
# Table name: piazza_activity_downloads
#
#  id             :uuid             not null, primary key
#  activity_from  :datetime         not null
#  activity_until :datetime         not null
#  csv_filename   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cohort_id      :uuid             not null
#
# Indexes
#
#  index_piazza_activity_downloads_on_cohort_id  (cohort_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#
class PiazzaActivityDownload < ApplicationRecord
  attr_accessor :csv_file

  belongs_to :cohort

  has_many :piazza_activity_breakdowns, dependent: :destroy

  validates :activity_from, presence: true
  validates :activity_until,
    presence: true,
    uniqueness: {scope: [:activity_from, :cohort]}
  validates :csv_file, presence: true

  after_create :process_csv

  scope :default_order, -> { order(activity_until: :desc) }

  def activity_from_humanized
    activity_from.strftime("%Y-%m-%d")
  end

  def activity_until_humanized
    activity_until.strftime("%Y-%m-%d")
  end

  def process_csv
    ActiveRecord::Base.transaction do
      self.update(csv_filename: csv_file.original_filename)

      options = {key_mapping: {"live_q&a_upvotes": :live_qa_upvotes}}

      csv = SmarterCSV.process(csv_file, options)

      csv.each do |row|
        emails = row.fetch(:emails).split(";").map(&:strip)

        user = User.where(email: emails).first
        
        if user.blank?
          user = User.new(email: emails.first, password: SecureRandom.hex(16))       
        end

        user.piazza_full = row.fetch(:name, "None provided")
        user.save

        enrollment = Enrollment.find_or_create_by(user: user, cohort: cohort) do |the_enrollment|
          the_enrollment.role = row.fetch(:role)
        end

        piazza_activity_breakdown = piazza_activity_breakdowns.
          create(enrollment:, **row)
      end
    end
  end
end
