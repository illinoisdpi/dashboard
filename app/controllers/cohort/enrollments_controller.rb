class Cohort::EnrollmentsController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment, only: %i[show overview snapshot edit update destroy]
  before_action { authorize(@enrollment || Enrollment) }

  # GET /enrollments or /enrollments.json
  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Enrollments", href: cohort_enrollments_path(@cohort) }
    ]

    @enrollments = policy_scope(@cohort.enrollments.includes(:user))
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Enrollments", href: cohort_enrollments_path(@cohort) },
      { content: @enrollment.name }
    ]
  end

  # GET /enrollments/new
  def new
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Enrollments", href: cohort_enrollments_path(@cohort) },
      { content: "New" }
    ]
    @enrollment = @cohort.enrollments.new
  end

  # GET /enrollments/1/edit
  def edit
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Enrollments", href: cohort_enrollments_path(@cohort) },
      { content: @enrollment.name },
      { content: "Edit" }
    ]
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment = @cohort.enrollments.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to cohort_enrollments_url(@cohort), notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to cohort_enrollments_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to cohort_enrollments_url(@cohort), notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def overview
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Enrollments", href: cohort_enrollments_path(@cohort) },
      { content: @enrollment.name }
    ]
  end

  def snapshot
    render layout: "navbarless"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = Cohort.find(params.fetch(:cohort_id))
  end

  def set_enrollment
    @enrollment = policy_scope(@cohort.enrollments).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(
      :id, :role, :user_id, :cohort_id,
      user_attributes: [
        :id,
        :email,
        :salesforce_id,
        :discord_id,
        :discord_username,
        :github_username,
        :devto_username
      ]
    )
  end
end
