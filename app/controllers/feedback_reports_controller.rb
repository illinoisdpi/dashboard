class FeedbackReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_canvas_gradebook_snapshot
  before_action { authorize(FeedbackReport) }

  def create
    if policy(FeedbackReport).create?
      FeedbackReportService.new(
        @canvas_gradebook_snapshot,
        Date.parse(params[:start_date]),
        Date.parse(params[:end_date]),
        params[:assignments]
      ).generate_and_send_reports

      redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot),
                  notice: "Feedback reports sent successfully!"
    else
      redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot),
                  alert: "You are not authorized to send feedback reports."
    end
  rescue => e
    redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot),
                alert: "Error sending reports: #{e.message}"
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_canvas_gradebook_snapshot
    @canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])
  end
end
