class AddFrequencyToRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :recurring_messages, :frequency, :string, null: false, default: "weekly"
  end
end
