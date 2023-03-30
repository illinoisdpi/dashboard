class AddStartedOnToCohorts < ActiveRecord::Migration[7.0]
  def change
    add_column :cohorts, :started_on, :date
  end
end
