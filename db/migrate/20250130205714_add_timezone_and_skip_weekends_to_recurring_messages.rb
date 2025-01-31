class AddTimezoneAndSkipWeekendsToRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :recurring_messages, :timezone, :string
    add_column :recurring_messages, :skip_weekends, :boolean
  end
end
