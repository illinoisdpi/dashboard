class EnrollmentsController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment, only: %i[show edit update destroy]

  # GET /enrollments or /enrollments.json
  def index
    authorize @cohort

    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Enrollments", href: cohort_enrollments_path(@cohort)}
    ]
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    authorize @enrollment

    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Enrollments", href: cohort_enrollments_path(@cohort)},
      {content: @enrollment.to_s}
    ]
  end

  # GET /enrollments/new
  def new
    authorize Enrollment

    @enrollment = @cohort.enrollments.new
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    authorize Enrollment

    @enrollment = @cohort.enrollments.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment

    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = Cohort.find(params.fetch(:cohort_id))
  end

  def set_enrollment
    @enrollment = @cohort.enrollments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:role, :user_id, :cohort_id)
  end
end
