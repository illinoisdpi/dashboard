class AddSnapshotAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :fun_fact, :text
    add_column :users, :first_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :last_name, :string
    add_column :users, :one_liner, :text
    add_column :users, :skills_and_projects, :text
    add_column :users, :career_highlights, :text
    add_column :enrollments, :skills_development, :text
  end
end
