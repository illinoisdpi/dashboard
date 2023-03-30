module Enrollment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      edit do
        include_fields :career_attendance,
          :career_calendar_management,
          :career_customer_service,
          :career_networking,
          :career_problem_solving,
          :career_punctuality,
          :career_quality_of_work,
          :career_response_to_supervision,
          :career_summary,
          :career_taking_initiative,
          :career_task_management,
          :career_teamwork,
          :career_workplace_appearance,
          :career_workplace_culture,
          :communication_nonverbal,
          :communication_summary,
          :communication_verbal,
          :communication_written,
          :emotional_intelligence,
          :id_from_canvas,
          :role,
          :staff_areas_for_growth,
          :staff_strengths,
          :technical_good_questions,
          :technical_progress
      end
    end
  end
end
