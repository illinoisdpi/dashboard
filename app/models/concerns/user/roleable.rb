module User::Roleable
  extend ActiveSupport::Concern

  def admin?
    has_role? :admin
  end

  def cohort_staff?(cohort)
    enrollments.where(cohort:, role: :staff).exists?
  end

  def cohort_student?(cohort)
    enrollments.where(cohort:, role: :student).exists?
  end

  def cohort_instructor?(cohort)
    enrollments.where(cohort:, role: :instructor).exists?
  end

  def cohort_teaching_assistant?(cohort)
    enrollments.where(cohort:, role: :teaching_assistant).exists?
  end

  def staff?
    enrollments.where(role: :staff).exists?
  end

  def student?
    enrollments.where(role: :student).exists?
  end

  def instructor?
    enrollments.where(role: :instructor).exists?
  end

  def teaching_assistant?
    enrollments.where(role: :teaching_assistant).exists?
  end
end
