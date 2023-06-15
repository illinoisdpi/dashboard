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
  has_paper_trail skip: [:created_at, :updated_at]

  belongs_to :author, class_name: "User", foreign_key: "author_id"
  belongs_to :subject, class_name: "Enrollment", foreign_key: "subject_id"

  validates :content, presence: true
  validates :emoji, emoji: true

  EMOJIS = %w[😊 😢 😠 😄 🤯 😵‍💫 😭 🤥 🫣 🥴 🤑 🤮 🙁 🥳 🤩 😇 😎 😅].freeze
end
