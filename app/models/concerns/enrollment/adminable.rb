module Enrollment::Adminable
  extend ActiveSupport::Concern

  included do
    rails_admin do

      list do
        field :role
        field :career_attendance              
        field :career_calendar_management     
        field :career_customer_service        
        field :career_networking              
        field :career_problem_solving         
        field :career_punctuality             
        field :career_quality_of_work         
        field :career_response_to_supervision 
        field :career_summary  
        field :career_taking_initiative       
        field :career_task_management         
        field :career_teamwork                
        field :career_total                   
        field :career_workplace_appearance    
        field :career_workplace_culture       
        field :communication_nonverbal        
        field :communication_summary
        field :communication_total            
        field :communication_verbal           
        field :communication_written          
        field :emotional_intelligence
        field :id_from_canvas
        field :technical_good_questions       
        field :technical_progress             
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
          :technical_progress,
          :skills_development
      end
    end
  end
end
