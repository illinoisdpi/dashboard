class AddUniqueIndexToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_index :enrollments, [ :user_id, :cohort_id ], unique: true
  end
end
