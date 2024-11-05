module User::Roleable
  extend ActiveSupport::Concern

  def admin?
    has_role? :admin
  end

  def cohort_staff?(cohort)
    enrollments.exists?(cohort:, role: :staff)
  end

  def cohort_student?(cohort)
    enrollments.exists?(cohort:, role: :student)
  end

  def cohort_instructor?(cohort)
    enrollments.exists?(cohort:, role: :instructor)
  end

  def cohort_teaching_assistant?(cohort)
    enrollments.exists?(cohort:, role: :teaching_assistant)
  end

  def staff?
    enrollments.exists?(role: :staff)
  end

  def student?
    enrollments.exists?(role: :student)
  end

  def instructor?
    enrollments.exists?(role: :instructor)
  end

  def teaching_assistant?
    enrollments.exists?(role: :teaching_assistant)
  end
end
