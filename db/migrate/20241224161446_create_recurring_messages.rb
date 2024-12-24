class CreateRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :recurring_messages, id: :uuid do |t|
      t.references :cohort, foreign_key: true, type: :uuid
      t.string :channel_id
      t.text :message_content
      t.integer :recurrence_pattern, default: 0
      t.string :cron_expression
      t.datetime :next_run_at
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
