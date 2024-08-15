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
require 'rails_helper'

RSpec.describe Shoutout, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
