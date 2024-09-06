module Enrollment::Endorsable
  extend ActiveSupport::Concern

  included do
    before_validation :set_career_total
    before_validation :set_communication_total

    enum technical_rating: {
      emerging: "emerging",
      proficient: "proficient",
      excellent: "excellent"
    }
  end

  def set_career_total
    self.career_total = career_attendance +
      career_punctuality +
      career_workplace_appearance +
      career_workplace_culture +
      career_taking_initiative +
      career_quality_of_work +
      career_networking +
      career_response_to_supervision +
      career_teamwork +
      career_customer_service +
      career_problem_solving +
      career_calendar_management +
      career_task_management
  end

  def set_communication_total
    self.communication_total = communication_nonverbal +
      communication_verbal +
      communication_written
  end

  def technical_score
    technical_total / cohort.included_canvas_assignments.sum(:points_possible)
  end

  def technical_total
    technical_project_points + technical_good_questions
  end

  def technical_project_points
    latest_gradebook = cohort.canvas_gradebook_snapshots.order(created_at: :desc).first

    latest_gradebook.canvas_submissions.where(enrollment: self, canvas_assignment: CanvasAssignment.included).sum(:points)
  end

  def career_rating
    if career_total >= 46
      :excellent
    elsif career_total >= 41
      :proficient
    else
      :emerging
    end
  end

  def communication_rating
    if communication_total >= 10.5
      :excellent
    elsif communication_total >= 8.5
      :proficient
    else
      :emerging
    end
  end
end
