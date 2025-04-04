class Cohort::FeedbackReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment
  before_action { authorize(FeedbackReport) }

  def show
    @feedback_report = @enrollment.feedback_reports.find(params[:id])
    authorize @feedback_report
  end

  def create
    if policy(FeedbackReport).create?
      canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])

      FeedbackReportService.new(
        canvas_gradebook_snapshot,
        @enrollment,
        Date.parse(params[:start_date]),
        Date.parse(params[:end_date]),
        params[:assignments]
      ).generate_report

      redirect_to cohort_enrollment_path(@cohort, @enrollment),
                  notice: "Feedback report generated successfully!"
    else
      redirect_to cohort_enrollment_path(@cohort, @enrollment),
                  alert: "You are not authorized to generate feedback reports."
    end
  rescue => e
    redirect_to cohort_enrollment_path(@cohort, @enrollment),
                alert: "Error generating report: #{e.message}"
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_enrollment
    @enrollment = @cohort.enrollments.find(params[:enrollment_id])
  end
end
