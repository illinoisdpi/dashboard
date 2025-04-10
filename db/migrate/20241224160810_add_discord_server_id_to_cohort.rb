class AddDiscordServerIdToCohort < ActiveRecord::Migration[7.0]
  def change
    add_column :cohorts, :discord_server_id, :string
  end
end
