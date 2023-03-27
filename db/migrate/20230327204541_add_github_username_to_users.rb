class AddGithubUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_username, :string
    add_index :users, :github_username, unique: true
  end
end
