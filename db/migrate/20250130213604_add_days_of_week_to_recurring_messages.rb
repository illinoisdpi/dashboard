class AddDaysOfWeekToRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :recurring_messages, :days_of_week, :string, array: true, default: []
    add_column :recurring_messages, :scheduled_time, :time
    remove_column :recurring_messages, :rrule
  end
end
