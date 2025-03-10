class AddJobIdToRecurringMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :recurring_messages, :job_id, :string
  end
end
