class AddProfileColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :quote, :text
    add_column :users, :personal_website, :string
    add_column :users, :most_recent_role, :text
    add_column :users, :languages, :text
    add_column :users, :strengths, :text
    add_column :users, :education, :text

    add_column :enrollments, :career_total, :integer, default: 0
    add_column :enrollments, :career_summary, :text
    add_column :enrollments, :career_attendance, :integer, default: 0
    add_column :enrollments, :career_punctuality, :integer, default: 0
    add_column :enrollments, :career_workplace_appearance, :integer, default: 0
    add_column :enrollments, :career_workplace_culture, :integer, default: 0
    add_column :enrollments, :career_taking_initiative, :integer, default: 0
    add_column :enrollments, :career_quality_of_work, :integer, default: 0
    add_column :enrollments, :career_networking, :integer, default: 0
    add_column :enrollments, :career_response_to_supervision, :integer, default: 0
    add_column :enrollments, :career_teamwork, :integer, default: 0
    add_column :enrollments, :career_customer_service, :integer, default: 0
    add_column :enrollments, :career_problem_solving, :integer, default: 0
    add_column :enrollments, :career_calendar_management, :integer, default: 0
    add_column :enrollments, :career_task_management, :integer, default: 0

    add_column :enrollments, :communication_total, :integer, default: 0
    add_column :enrollments, :communication_summary, :text
    add_column :enrollments, :communication_nonverbal, :integer, default: 0
    add_column :enrollments, :communication_verbal, :integer, default: 0
    add_column :enrollments, :communication_written, :integer, default: 0

    add_column :enrollments, :technical_progress, :integer, default: 0
    add_column :enrollments, :technical_good_questions, :integer, default: 0

    add_column :enrollments, :emotional_intelligence, :text
    add_column :enrollments, :staff_strengths, :text
    add_column :enrollments, :staff_areas_for_growth, :text
  end
end
