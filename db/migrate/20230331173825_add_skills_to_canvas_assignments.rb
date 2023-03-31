class AddSkillsToCanvasAssignments < ActiveRecord::Migration[7.0]
  def change
    add_column :canvas_assignments, :css, :integer
    add_column :canvas_assignments, :databases, :integer
    add_column :canvas_assignments, :authentication, :integer
    add_column :canvas_assignments, :domain_modeling, :integer
    add_column :canvas_assignments, :javascript, :integer
  end
end
