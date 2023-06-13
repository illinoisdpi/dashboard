class AddHeadshotToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :headshot, :string
  end
end
