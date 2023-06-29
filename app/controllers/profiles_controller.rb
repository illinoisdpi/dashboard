class ProfilesController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment, only: [:show, :snapshot]
  before_action { authorize(:profile) }

  def index
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Profiles", href: cohort_profiles_path(@cohort)}
    ]

    @profiles = policy_scope(@cohort.enrollments, policy_scope_class: ProfilePolicy::Scope).student.default_order
  end

  def show
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Profiles", href: cohort_profiles_path(@cohort)},
      {content: @enrollment.to_s}
    ]
  end

  def snapshot
    render layout: "navbarless"
  end

  private

  def set_cohort
    @cohort = Cohort.find(params.fetch(:cohort_id))
  end

  def set_enrollment
    @enrollment = @cohort.enrollments.find(params[:id])
  end
end
