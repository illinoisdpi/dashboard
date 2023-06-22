# == Schema Information
#
# Table name: devto_posts
#
#  id           :uuid             not null, primary key
#  published_at :datetime
#  title        :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid             not null
#
# Indexes
#
#  index_devto_posts_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
require 'rails_helper'

RSpec.describe DevtoPost, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
