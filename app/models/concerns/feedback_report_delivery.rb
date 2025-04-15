module FeedbackReportDelivery
  extend ActiveSupport::Concern

  def send_report
    Rails.logger.info("[FeedbackReportDelivery] Sending report #{id} for #{enrollment.user}")

    # Pre-check: Validate that the user has a Discord ID
    if enrollment.user.discord_id.blank?
      error_message = "User #{enrollment.user.name} does not have a Discord ID set. Please set their Discord ID in the cohort enrollment edit page."
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

      [ true, "Feedback report was successfully sent." ]
    rescue => e
      mark_as_failed!(e)
      [ false, e.message ]
    end
  end
end
