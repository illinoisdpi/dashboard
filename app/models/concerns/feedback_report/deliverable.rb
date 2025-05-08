module FeedbackReport::Deliverable
  extend ActiveSupport::Concern

  def send_report
    Rails.logger.info("[FeedbackReportDelivery] Attempting to send report #{id} for #{enrollment.user.name}")

    if enrollment.user.discord_id.blank?
      error_message = "User #{enrollment.user.name} does not have a Discord ID set. Report #{id} cannot be sent."
      Rails.logger.warn("[FeedbackReportDelivery] #{error_message}")
      mark_as_failed!(StandardError.new(error_message))
      return [false, error_message]
    end

    begin
      current_cohort = self.enrollment&.cohort || self.canvas_gradebook_snapshot&.cohort
      unless current_cohort
        error_message = "Cannot determine cohort for FeedbackReport #{id}. Report cannot be sent."
        Rails.logger.error("[FeedbackReportDelivery] #{error_message}")
        mark_as_failed!(StandardError.new(error_message))
        return [false, error_message]
      end

      self.class.send(:_send_feedback_report, self, self.enrollment, current_cohort)
      
      success_message = "Feedback report was successfully sent to #{enrollment.user.name}."
      Rails.logger.info("[FeedbackReportDelivery] #{success_message}")
      [true, success_message]
    rescue => e
      error_message = "Failed to send feedback report for #{enrollment.user.name}: #{e.message}"
      Rails.logger.error("[FeedbackReportDelivery] #{error_message}\nBacktrace: #{e.backtrace.join("\n")}")
      mark_as_failed!(e)
      [false, error_message]
    end
  end
end
