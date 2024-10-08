class CreateCohorts < ActiveRecord::Migration[7.0]
  def change
    create_table :cohorts, id: :uuid do |t|
      t.string :name
      t.integer :year, null: false
      t.integer :generation, null: false
      t.integer :number, null: false
      t.string :piazza_course_number

      t.timestamps
    end
  end
end
