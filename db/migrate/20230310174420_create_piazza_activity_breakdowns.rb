class CreatePiazzaActivityBreakdowns < ActiveRecord::Migration[7.0]
  def change
    create_table :piazza_activity_breakdowns, id: :uuid do |t|
      t.references :enrollment, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :emails, null: false
      t.string :role, null: false
      t.string :groups
      t.integer :days_online, null: false
      t.integer :posts, null: false
      t.integer :edits_to_posts, null: false
      t.integer :answers, null: false
      t.integer :edits_to_answers, null: false
      t.integer :followups, null: false
      t.integer :replies_to_followups, null: false
      t.integer :instructor_good_question, null: false
      t.integer :instructor_good_answer, null: false
      t.integer :instructor_good_comment, null: false
      t.integer :student_good_question, null: false
      t.integer :student_thanks_on_answer, null: false
      t.integer :student_helpful_on_followups, null: false
      t.integer :good_question_given, null: false
      t.integer :thanks_on_answers_given, null: false
      t.integer :helpful_on_followups_given, null: false
      t.integer :post_views, null: false
      t.integer :live_qa_upvotes, null: false
      t.references :piazza_activity_report, null: false, foreign_key: true, type: :uuid, index: { name: :index_piazza_activity_breakdowns_on_reports_id }

      t.timestamps
    end
  end
end
