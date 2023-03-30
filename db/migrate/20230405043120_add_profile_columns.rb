class AddProfileColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :quote, :text
    add_column :users, :personal_website, :string
    add_column :users, :most_recent_role, :text
    add_column :users, :languages, :text
    add_column :users, :strengths, :text
    add_column :users, :education, :text

    add_column :enrollments, :career_total, :integer
    add_column :enrollments, :career_summary, :text
    add_column :enrollments, :career_attendance, :integer
    add_column :enrollments, :career_punctuality, :integer
    add_column :enrollments, :career_workplace_appearance, :integer
    add_column :enrollments, :career_workplace_culture, :integer
    add_column :enrollments, :career_taking_initiative, :integer
    add_column :enrollments, :career_quality_of_work, :integer
    add_column :enrollments, :career_networking, :integer
    add_column :enrollments, :career_response_to_supervision, :integer
    add_column :enrollments, :career_teamwork, :integer
    add_column :enrollments, :career_customer_service, :integer
    add_column :enrollments, :career_problem_solving, :integer
    add_column :enrollments, :career_calendar_management, :integer
    add_column :enrollments, :career_task_management, :integer

    add_column :enrollments, :communication_total, :integer
    add_column :enrollments, :communication_summary, :text
    add_column :enrollments, :communication_nonverbal, :integer
    add_column :enrollments, :communication_verbal, :integer
    add_column :enrollments, :communication_written, :integer

    add_column :enrollments, :technical_progress, :integer
    add_column :enrollments, :technical_good_questions, :integer

    add_column :enrollments, :emotional_intelligence, :text
    add_column :enrollments, :staff_strengths, :text
    add_column :enrollments, :staff_areas_for_growth, :text
  end
end
