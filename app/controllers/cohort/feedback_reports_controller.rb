class Cohort::FeedbackReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_feedback_report, only: [ :show, :send_report, :destroy, :edit, :update ]
  before_action :set_enrollment, except: [ :batch_create, :index, :show, :new, :create, :send_report, :destroy, :edit, :update ]
  before_action { authorize(@feedback_report || FeedbackReport) }

  def index
    @feedback_reports = policy_scope(@cohort.feedback_reports)
      .order(created_at: :desc)
      .includes(enrollment: :user)
  end

  def show
    @feedback_report = @cohort.feedback_reports.find(params[:id])
    authorize @feedback_report
  end

  def batch_create
    if policy(FeedbackReport).create?
      begin
        canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        assignments = params[:assignments]

        result = FeedbackReport.batch_create(
          @cohort,
          canvas_gradebook_snapshot,
          start_date,
          end_date,
          assignments
        )

        redirect_to cohort_feedback_reports_path(@cohort), notice: result[:message]
      rescue => e
        Rails.logger.error("Fatal error in batch_create: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        redirect_to cohort_feedback_reports_path(@cohort), alert: "Error generating reports: #{e.message}\n#{e.backtrace.first}"
      end
    else
      redirect_to cohort_feedback_reports_path(@cohort), alert: "You are not authorized to generate feedback reports."
    end
  end

  def edit
  end

  def send_report
    begin
      @feedback_report.send_report
      redirect_to cohort_feedback_reports_path(@cohort), notice: "Feedback report was successfully sent."
    rescue => e
      redirect_to cohort_feedback_reports_path(@cohort), alert: "Failed to send feedback report: #{e.message}"
    end
  end

  def update
    if @feedback_report.update(feedback_report_params)
      redirect_to cohort_feedback_report_path(@cohort, @feedback_report), notice: "Feedback report was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @feedback_report.destroy

    respond_to do |format|
      format.html { redirect_to cohort_feedback_reports_path(@cohort), notice: "Feedback report was successfully deleted." }
      format.json { head :no_content }
    end
  rescue => e
    Rails.logger.error("[FeedbackReportsController] Failed to delete report #{@feedback_report.id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    respond_to do |format|
      format.html { redirect_to cohort_feedback_report_path(@cohort, @feedback_report), alert: "Failed to delete feedback report: #{e.message}" }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_enrollment
    @enrollment = @cohort.enrollments.find(params[:enrollment_id])
  end

  def set_feedback_report
    @feedback_report = @cohort.feedback_reports.find(params[:id])
  end

  def feedback_report_params
    params.require(:feedback_report).permit(:message)
  end
end
