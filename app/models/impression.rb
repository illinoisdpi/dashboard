# == Schema Information
#
# Table name: impressions
#
#  id         :uuid             not null, primary key
#  content    :text             not null
#  emoji      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :uuid             not null
#  subject_id :uuid             not null
#
# Indexes
#
#  index_impressions_on_author_id   (author_id)
#  index_impressions_on_subject_id  (subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (subject_id => enrollments.id)
#
class Impression < ApplicationRecord
  include Csvable, Emojiable, Ransackable, Slackable

  has_paper_trail skip: [:created_at, :updated_at]

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :subject, class_name: "Enrollment", foreign_key: "subject_id"

  validates :content, presence: true

  scope :default_order, -> { order(created_at: :desc) }

  scope :positive, -> { where(emoji: Emojiable.positive_emojis) }
  scope :negative, -> { where(emoji: Emojiable.negative_emojis) }

  scope :last_week, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  scope :last_month, -> { where(created_at: 1.month.ago.beginning_of_day..Time.current.end_of_day) }
  scope :by_time_period, ->(time_period) { respond_to?(time_period) ? send(time_period) : all }

  scope :for_category, ->(category) {
    emojis_in_category = EMOJIS.select { |_, v| v[:category].casecmp?(category) }.keys
    where(emoji: emojis_in_category)
  }

  scope :for_category, ->(category) {
    where(emoji: Emojiable.emojis_for_category(category))
  }

  def summary
    "#{author} authored a #{emoji_sentiment} #{emoji_category} impression (#{emoji_description}) for #{subject} #{emoji}"
  end

  def to_s
    summary
  end
end
