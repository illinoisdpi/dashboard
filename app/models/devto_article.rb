# == Schema Information
#
# Table name: devto_articles
#
#  id           :uuid             not null, primary key
#  description  :text
#  published_at :datetime
#  title        :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  author_id    :uuid             not null
#  devto_id     :integer
#
# Indexes
#
#  index_devto_articles_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
class DevtoArticle < ApplicationRecord
  include Ransackable

  belongs_to :author, class_name: "User"

  scope :default_order, -> { order(published_at: :desc) }
end
