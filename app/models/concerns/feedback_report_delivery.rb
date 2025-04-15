module FeedbackReportDelivery
  extend ActiveSupport::Concern

  def send_report
    Rails.logger.info("[FeedbackReportDelivery] Sending report #{id} for #{enrollment.user}")

    # Pre-check: Validate that the user has a Discord ID
    if enrollment.user.discord_id.blank?
      error_message = "User #{enrollment.user.name} does not have a Discord ID set. Please set their Discord ID in the admin interface."
      Rails.logger.error("[FeedbackReportDelivery] #{error_message}")
      mark_as_failed!(StandardError.new(error_message))
      return [ false, error_message ]
    end

    begin
      service = FeedbackReportService.new(
        canvas_gradebook_snapshot,
        start_date,
        end_date,
        canvas_gradebook_snapshot.canvas_assignments.pluck(:id)
      )

      service.send_feedback_report(self, enrollment)
      Rails.logger.info("[FeedbackReportDelivery] Successfully sent report to #{enrollment.user}")

      [ true, "Feedback report was successfully sent." ]
    rescue => e
      Rails.logger.error("[FeedbackReportDelivery] Failed to send report #{id}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      mark_as_failed!(e)
      [ false, e.message ]
    end
  end
end
