class AddCanvasFullToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :canvas_full, :string
  end
end
