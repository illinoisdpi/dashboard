# == Schema Information
#
# Table name: impression_comments
#
#  id            :uuid             not null, primary key
#  content       :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  impression_id :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_impression_comments_on_impression_id  (impression_id)
#  index_impression_comments_on_user_id        (user_id)
#
class ImpressionComment < ApplicationRecord
  belongs_to :impression
  belongs_to :user

  validates :content, presence: true
end
