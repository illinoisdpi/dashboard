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
  include Emojiable, Ransackable, Slackable

  has_paper_trail skip: [:created_at, :updated_at]

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :subject, class_name: "Enrollment", foreign_key: "subject_id"

  validates :content, presence: true

  scope :default_order, -> { order(created_at: :desc) }

  scope :positive, -> { where(emoji: POSITIVE_EMOJIS) }
  scope :negative, -> { where(emoji: NEGATIVE_EMOJIS) }

  scope :for_subject, ->(user) { where(subject_id: user.enrollments.pluck(:id)) }
  scope :positive_for_subject, ->(user) { positive.for_subject(user) }
  scope :negative_for_subject, ->(user) { negative.for_subject(user) }

  scope :positive_by_category, ->(user, category) {
    emojis_in_category = Impression::Emojiable::EMOJI_CATEGORIES.select { |_, cat| cat == category }.keys
    where(emoji: emojis_in_category & Impression::Emojiable::POSITIVE_EMOJIS).for_subject(user)
  }

  scope :negative_by_category, ->(user, category) {
    emojis_in_category = Impression::Emojiable::EMOJI_CATEGORIES.select { |_, cat| cat == category }.keys
    where(emoji: emojis_in_category & Impression::Emojiable::NEGATIVE_EMOJIS).for_subject(user)
  }

  def summary
    "#{emoji} #{author} authored a #{emoji_category} (#{emoji_description}) impression of #{subject} #{emoji}"
  end

  def to_s
    summary
  end
end
