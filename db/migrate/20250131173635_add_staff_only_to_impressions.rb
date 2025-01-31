class AddStaffOnlyToImpressions < ActiveRecord::Migration[7.0]
  def change
    add_column :impressions, :staff_only, :boolean
  end
end
