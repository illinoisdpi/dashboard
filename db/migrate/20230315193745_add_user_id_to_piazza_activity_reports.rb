class AddUserIdToPiazzaActivityReports < ActiveRecord::Migration[7.0]
  def change
    add_reference :piazza_activity_reports, :user, null: false, foreign_key: true, type: :uuid
  end
end
