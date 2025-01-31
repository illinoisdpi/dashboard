class ChangeCronToRruleInRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :recurring_messages, :cron_expression
    add_column :recurring_messages, :rrule, :text
  end
end
