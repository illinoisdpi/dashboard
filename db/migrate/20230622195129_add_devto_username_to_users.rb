class AddDevtoUsernameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :devto_username, :string
  end
end
