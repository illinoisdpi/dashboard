class AddByDpiToPlacements < ActiveRecord::Migration[7.0]
  def change
    add_column :placements, :by_dpi, :boolean, default: true
  end
end
