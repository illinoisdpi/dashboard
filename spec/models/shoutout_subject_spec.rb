# == Schema Information
#
# Table name: shoutout_subjects
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  shoutout_id :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_shoutout_subjects_on_shoutout_id  (shoutout_id)
#  index_shoutout_subjects_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shoutout_id => shoutouts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ShoutoutSubject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
