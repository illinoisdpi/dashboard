class ChangeCohortAttributeGenerationToMonth < ActiveRecord::Migration[7.0]
  def change
    rename_column :cohorts, :generation, :month
  end
end
