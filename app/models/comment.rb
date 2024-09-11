# == Schema Information
#
# Table name: comments
#
#  id               :uuid             not null, primary key
#  commentable_type :string           not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :uuid             not null
#  impression_id    :uuid             not null
#  user_id          :uuid             not null
#
# Indexes
#
#  index_comments_on_commentable    (commentable_type,commentable_id)
#  index_comments_on_impression_id  (impression_id)
#  index_comments_on_user_id        (user_id)
#
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :impression

  validates :content, presence: true
end
