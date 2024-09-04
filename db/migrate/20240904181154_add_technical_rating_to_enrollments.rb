class AddTechnicalRatingToEnrollments < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :technical_rating, :integer
  end
end
