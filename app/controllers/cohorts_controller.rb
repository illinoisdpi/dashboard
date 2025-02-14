class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[show edit update destroy canvas_highest_position_submission_count canvas_point_total_most_recent canvas_cumulative_points]
  before_action { authorize(@cohort || Cohort) }

  # GET /cohorts or /cohorts.json
  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path }
    ]

    @cohorts = policy_scope(Cohort).all.default_order
  end

  # GET /cohorts/1 or /cohorts/1.json
  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) }
    ]
  end

  # GET /cohorts/new
  def new
    @cohort = Cohort.new
  end

  # GET /cohorts/1/edit
  def edit
  end

  # POST /cohorts or /cohorts.json
  def create
    @cohort = Cohort.new(cohort_params)

    respond_to do |format|
      if @cohort.save
        format.html { redirect_to cohort_url(@cohort), notice: "Cohort was successfully created." }
        format.json { render :show, status: :created, location: @cohort }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cohorts/1 or /cohorts/1.json
  def update
    respond_to do |format|
      if @cohort.update(cohort_params)
        format.html { redirect_to cohort_url(@cohort), notice: "Cohort was successfully updated." }
        format.json { render :show, status: :ok, location: @cohort }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cohort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cohorts/1 or /cohorts/1.json
  def destroy
    @cohort.destroy

    respond_to do |format|
      format.html { redirect_to cohorts_url, notice: "Cohort was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def canvas_highest_position_submission_count
    render json: @cohort
      .canvas_assignments
      .group_by_highest_position_submission_count
      .map { |canvas_assignment| [ canvas_assignment.name, canvas_assignment.student_count ] }
  end

  def canvas_point_total_most_recent
    render json:  @cohort
      .enrollments
      .with_recent_canvas_points(@cohort)
      .map { |enrollment| [ enrollment.name, enrollment.total_points ] }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = policy_scope(Cohort).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cohort_params
    params.require(:cohort).permit(:name, :started_on, :year, :month, :number, :piazza_course_number, :canvas_shortname)
  end
end
