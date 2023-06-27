class PiazzaActivityReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_piazza_activity_report, only: %i[show edit update destroy]
  before_action { authorize(PiazzaActivityReports) }

  # GET /piazza_activity_reports or /piazza_activity_reports.json
  def index
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_reports_path(@cohort)}
    ]

    @piazza_activity_reports = @cohort.piazza_activity_reports.default_order
  end

  # GET /piazza_activity_reports/1 or /piazza_activity_reports/1.json
  def show
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_reports_path(@cohort)},
      {content: @piazza_activity_report.to_s}
    ]
    @q = @piazza_activity_report.piazza_activity_breakdowns.ransack(params[:q])
    @piazza_activity_breakdowns = @q.result
  end

  # GET /piazza_activity_reports/new
  def new
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_reports_path(@cohort)},
      {content: "New"}
    ]

    @piazza_activity_report = @cohort.piazza_activity_reports.build
  end

  # GET /piazza_activity_reports/1/edit
  def edit
  end

  # POST /piazza_activity_reports or /piazza_activity_reports.json
  def create
    @piazza_activity_report = PiazzaActivityReport.new(piazza_activity_report_params.merge(user: current_user))

    respond_to do |format|
      if @piazza_activity_report.save
        format.html { redirect_to cohort_piazza_activity_report_url(@piazza_activity_report.cohort, @piazza_activity_report), notice: "Piazza activity report was successfully created." }
        format.json { render :show, status: :created, location: @piazza_activity_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /piazza_activity_reports/1 or /piazza_activity_reports/1.json
  def update
    respond_to do |format|
      if @piazza_activity_report.update(piazza_activity_report_params)
        format.html { redirect_to cohort_piazza_activity_report_url(@piazza_activity_report.cohort, @piazza_activity_report), notice: "Piazza activity report was successfully updated." }
        format.json { render :show, status: :ok, location: @piazza_activity_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /piazza_activity_reports/1 or /piazza_activity_reports/1.json
  def destroy
    @piazza_activity_report.destroy

    respond_to do |format|
      format.html { redirect_to cohort_piazza_activity_reports_url(@cohort), notice: "Piazza activity report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_piazza_activity_report
    @piazza_activity_report = PiazzaActivityReport.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def piazza_activity_report_params
    params.require(:piazza_activity_report).permit(:activity_from, :activity_until, :cohort_id, :csv_file)
  end
end
