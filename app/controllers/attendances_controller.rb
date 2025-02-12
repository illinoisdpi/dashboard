class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  before_action :set_cohort
  before_action { authorize(@attendance || Attendance) }

  # GET /attendances or /attendances.json
  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Attendance", href: cohort_attendances_path(@cohort) }
    ]

    @attendances = policy_scope(@cohort.attendances.default_order).page(params[:page]).per(10)
  end

  # GET /attendances/1 or /attendances/1.json
  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Attendance", href: cohort_attendances_path(@cohort) },
      { content: @attendance.title }
    ]

    @attendance = Attendance.find(params[:id])
    @cohort = @attendance.cohort
    @enrollments = @cohort.enrollments.includes(:user)
  end

  # GET /attendances/new
  def new
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Attendance", href: cohort_attendances_path(@cohort) },
      { content: "New" }
    ]

    @attendance = @cohort.attendances.new
  end

  # GET /attendances/1/edit
  def edit
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Attendance", href: cohort_attendances_path(@cohort) },
      { content: "Edit" }
    ]

    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = @cohort.attendances.new(attendance_params.merge(roll_taker: current_user))

    respond_to do |format|
      if params[:select_all] == "selected_all"
        # IF "SELECET ALL STUDENTS BOX IS CLICKED, MATCH ALL ENROLLMENTS IN TO ALL ATTENDANCE ENROLLMENTS
        @attendance.enrollments = @attendance.cohort.enrollments
      else
        @attendance.enrollments = Enrollment.where(id: params[:enrollment_ids])
      end

      if @attendance.save
        # THIS EACH LOOP IS ATTACHING THE SELECTED ATTENDEES LINIKING ENROLLMENTS TO AN ATTENDANCE
        (params[:enrollment_ids] || []).each do |enrollment_id|
          @attendance.attendees.create(enrollment_id: enrollment_id)
        end

        format.html { redirect_to cohort_attendances_url(@cohort, @attendance), notice: "Attendance was successfully created." }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        @attendance.attendees.where.not(enrollment_id: params[:enrollment_ids]).destroy_all
        # SAME THIS THATS HAPPENING IN CREATE IS HAPPENING HERE
        (params[:enrollment_ids] || []).each do |enrollment_id|
          @attendance.attendees.find_or_create_by(enrollment_id: enrollment_id)
        end

        format.html { redirect_to cohort_attendance_url(@cohort, @attendance), notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to cohort_attendances_path(@cohort), notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def attendance_params
    params.require(:attendance).permit(:title, :category, :roll_taker_id, :cohort_id)
  end
end
