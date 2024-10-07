module Enrollment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do
      list do
        field :role

        rating_fields = [
          :career_attendance,
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
          :career_total,
          :career_workplace_appearance,
          :career_workplace_culture,
          :communication_nonverbal,
          :communication_summary,
          :communication_total,
          :communication_verbal,
          :communication_written,
          :technical_good_questions,
          :technical_progress,
          :emotional_intelligence
        ]
        rating_fields.each do |field_name|
          field field_name do
            visible do
              EnrollmentPolicy.new(bindings[:controller].current_user, bindings[:object]).view_rating?
            end
          end
        end

        field :id_from_canvas
        field :user do
          queryable true
          sticky true
          searchable [:canvas_full, :piazza_full]
        end

        field :cohort do
          queryable true
          searchable [:name]
        end
      end

      show do
        field :user
        field :id_from_canvas
        field :role
        field :skills_development

        rating_fields = [
          :career_attendance,
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
          :career_total,
          :career_workplace_appearance,
          :career_workplace_culture,
          :communication_nonverbal,
          :communication_summary,
          :communication_total,
          :communication_verbal,
          :communication_written,
          :technical_good_questions,
          :technical_progress,
          :emotional_intelligence,
          :staff_areas_for_growth,
          :staff_strengths
        ]
        rating_fields.each do |field_name|
          field field_name do
            visible do
              EnrollmentPolicy.new(bindings[:controller].current_user, bindings[:object]).view_rating?
            end
          end
        end
      end

      edit do
        field :id_from_canvas
        field :role
        field :skills_development

        rating_fields = [
          :career_attendance,
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
          :career_total,
          :career_workplace_appearance,
          :career_workplace_culture,
          :communication_nonverbal,
          :communication_summary,
          :communication_total,
          :communication_verbal,
          :communication_written,
          :technical_good_questions,
          :technical_progress,
          :emotional_intelligence,
          :staff_areas_for_growth,
          :staff_strengths
        ]
        rating_fields.each do |field_name|
          field field_name do
            visible do
              EnrollmentPolicy.new(bindings[:controller].current_user, bindings[:object]).view_rating?
            end
          end
        end
        field :user do
          visible do
            bindings[:controller].current_user.admin?
          end
        end
      end
    end
  end
end
