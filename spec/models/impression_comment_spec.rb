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
require 'rails_helper'

RSpec.describe ImpressionComment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
