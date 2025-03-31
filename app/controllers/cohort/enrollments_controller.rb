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

  # GET /cohorts/:cohort_id/enrollments/search
  def search
    @students = @cohort.enrollments.search_by_name(params[:name]).limit(10)

    respond_to do |format|
      format.json { render json: @students.map { |enrollment| { id: enrollment.id, name: enrollment.user.to_s, first_name: enrollment.user.first_name, last_name: enrollment.user.last_name, role: enrollment.role } } }
      format.turbo_stream
    end
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
    params.require(:enrollment).permit(:role, :user_id, :cohort_id, :skills_development)
  end
end
