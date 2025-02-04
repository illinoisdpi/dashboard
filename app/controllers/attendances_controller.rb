class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  before_action :set_cohort
  before_action { authorize(@attendance || Attendance) }

  # GET /attendances or /attendances.json
  def index
    @breadcrumbs = [
      { content: "Dashboard", href: dashboard_root_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Attendance", href: cohort_attendances_path(@cohort) }
    ]

    @attendances = policy_scope(@cohort.attendances).page(params[:page]).per(10) 
  end

  # GET /attendances/1 or /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, notice: "Attendance was successfully created." }
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
        format.html { redirect_to @attendance, notice: "Attendance was successfully updated." }
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
      format.html { redirect_to cohort_attendance_path, status: :see_other, notice: "Attendance was successfully destroyed." }
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
