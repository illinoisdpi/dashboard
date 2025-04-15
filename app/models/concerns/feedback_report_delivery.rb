module FeedbackReportDelivery
  extend ActiveSupport::Concern

  def send_report
    Rails.logger.info("[FeedbackReportDelivery] Sending report #{id} for #{enrollment.user}")

    service = FeedbackReportService.new(
      canvas_gradebook_snapshot,
      start_date,
      end_date,
      canvas_gradebook_snapshot.canvas_assignments.pluck(:id)
    )

    service.send_feedback_report(self, enrollment)
    Rails.logger.info("[FeedbackReportDelivery] Successfully sent report to #{enrollment.user}")

    true
  rescue => e
    Rails.logger.error("[FeedbackReportDelivery] Failed to send report #{id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    mark_as_failed!(e)
    raise e
  end
end
