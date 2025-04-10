class CreateRecurringMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :recurring_messages, id: :uuid do |t|
      t.references :cohort, foreign_key: true, type: :uuid
      t.string :channel_id
      t.text :message_content
      t.time :scheduled_time
      t.text :days_of_week, array: true, default: []
      t.string :frequency, null: false, default: "weekly"
      t.string :job_id

      t.timestamps
    end
  end
end
