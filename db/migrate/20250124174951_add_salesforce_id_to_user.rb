class AddSalesforceIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :salesforce_id, :string
  end
end
