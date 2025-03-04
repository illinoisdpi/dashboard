module User::Roleable
  extend ActiveSupport::Concern

  included do
    rolify
  end

  def admin?
    # Instead of querying the database every time admin? is called, cache (memoize) the result
    @is_admin ||= has_role? :admin
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
    @is_staff ||= enrollments.exists?(role: :staff)
  end

  def student?
    @is_student ||= enrollments.exists?(role: :student)
  end

  def instructor?
    @is_instructor ||= enrollments.exists?(role: :instructor)
  end

  def teaching_assistant?
    @is_teaching_assistant ||= enrollments.exists?(role: :teaching_assistant)
  end
end
