class AddCanvasShortnameToCohorts < ActiveRecord::Migration[7.0]
  def change
    add_column :cohorts, :canvas_shortname, :string
  end
end
