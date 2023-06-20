class CohortsController < ApplicationController
  before_action :set_cohort, only: %i[show edit update destroy]

  # GET /cohorts or /cohorts.json
  def index
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path}
    ]

    @cohorts = Cohort.all.default_order
  end

  # GET /cohorts/1 or /cohorts/1.json
  def show
    @cohort=Cohort.find(params[:id])
    begin 
      authorize @cohort
    rescue Exception => e 
      p "pundit exception:#{e} show Cohort #{@cohort.id} by user U#{@current_user.id}"
      respond_to do |format|
        format.html { redirect_to cohorts_url, alert: "Not authorized to show Cohort" }
        format.json { head :no_content }
      end
    else
      p "Show Cohort #{@cohort.id} by user U#{@current_user.id}"
      @breadcrumbs = [
        {content: "Cohorts", href: cohorts_path},
        {content: @cohort.to_s, href: cohort_path(@cohort)}
      ]
    end
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cohort
    @cohort = Cohort.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cohort_params
    params.require(:cohort).permit(:name, :started_on, :year, :generation, :number, :piazza_course_number, :canvas_shortname)
  end
end
