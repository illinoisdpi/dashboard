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

  belongs_to :author, class_name: "User"
  belongs_to :subject, class_name: "Enrollment"

  validates :content, presence: true

  scope :default_order, -> { order(created_at: :desc) }

  scope :for_category, ->(category) {
    emojis_in_category = Impression::Emojiable::EMOJIS.select { |_, v| v[:category].casecmp?(category) }.keys
    where(emoji: emojis_in_category)
  }

  def summary
    "#{author} authored a #{emoji_sentiment} #{emoji_category} impression (#{emoji_description}) for #{subject} #{emoji}"
  end

  def to_s
    summary
  end
end
