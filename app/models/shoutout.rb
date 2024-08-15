# == Schema Information
#
# Table name: shoutouts
#
#  id         :uuid             not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  user_id    :uuid             not null
#
# Indexes
#
#  index_shoutouts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Shoutout < ApplicationRecord
  belongs_to :user, foreign_key: "author_id"
  has_many :shoutout_subjects, dependent: :destroy

  validates :content, presence: true
end
