class AddSocialImageToDevtoArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :devto_articles, :social_image, :string
  end
end
