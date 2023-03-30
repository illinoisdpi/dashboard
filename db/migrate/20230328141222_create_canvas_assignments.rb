class CreateCanvasAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :canvas_assignments, id: :uuid do |t|
      t.boolean :excluded, default: false
      t.integer :points_possible
      t.string :name
      t.string :id_from_canvas
      t.integer :weight
      t.integer :html
      t.integer :ruby
      t.integer :rails
      t.references :cohort, null: false, foreign_key: true, type: :uuid
      t.integer :position

      t.timestamps
    end
  end
end
