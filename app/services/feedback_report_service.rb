class FeedbackReportService
  def initialize(canvas_gradebook_snapshot, start_date, end_date, assignment_ids)
    @canvas_gradebook_snapshot = canvas_gradebook_snapshot
    @cohort = canvas_gradebook_snapshot.cohort
    @start_date = start_date
    @end_date = end_date
    @assignment_ids = assignment_ids
    @discord_service = DiscordService.new(@cohort)
  end

  def create_feedback_report(enrollment)
    Rails.logger.info("[FeedbackReportService] Creating report for #{enrollment.user}")
    generate_feedback_report(enrollment)
  end

  def send_feedback_report(feedback_report, enrollment)
    Rails.logger.info("[FeedbackReportService] Sending feedback report for #{enrollment.user}")
    deliver_report(feedback_report, enrollment)
  rescue => e
    Rails.logger.error("[FeedbackReportService] Failed to send feedback report: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end

  private

  def generate_feedback_report(enrollment)
    Rails.logger.info("[FeedbackReportService] Generating report for enrollment #{enrollment.id} (#{enrollment.user})")

    selected_assignments = fetch_selected_assignments
    user_submissions = fetch_user_submissions(enrollment)
    missing_assignments = identify_missing_assignments(selected_assignments, user_submissions)
    impressions = fetch_student_impressions(enrollment)
    attendances = fetch_attendances(enrollment)

    message = format_feedback_message(enrollment, missing_assignments, impressions, attendances)
    create_report_record(enrollment, message)
  end

  def fetch_selected_assignments
    assignments = @canvas_gradebook_snapshot.canvas_assignments
      .where(id: @assignment_ids)
      .index_by(&:id)

    Rails.logger.info("[FeedbackReportService] Found #{assignments.size} assignments")
    assignments
  end

  def fetch_user_submissions(enrollment)
    submissions = @canvas_gradebook_snapshot.canvas_submissions
      .where(enrollment: enrollment)
      .where(canvas_assignment_id: @assignment_ids)
      .index_by(&:canvas_assignment_id)

    Rails.logger.info("[FeedbackReportService] Found #{submissions.size} submissions")
    submissions
  end

  def identify_missing_assignments(selected_assignments, user_submissions)
    missing = selected_assignments.values.reject do |assignment|
      user_submissions.key?(assignment.id)
    end

    Rails.logger.info("[FeedbackReportService] Found #{missing.size} missing assignments")
    missing
  end

  def fetch_student_impressions(enrollment)
    impressions = enrollment.impressions
      .where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
      .where(staff_only: false)
      .order(created_at: :desc)

    Rails.logger.info("[FeedbackReportService] Found #{impressions.size} impressions for date range #{@start_date} to #{@end_date}")
    impressions
  end

  def fetch_attendances(enrollment)
    attendances = enrollment.attendances
      .where(occurred_at: @start_date.beginning_of_day..@end_date.end_of_day)
      .order(occurred_at: :desc)

    Rails.logger.info("[FeedbackReportService] Found #{attendances.size} attendances for date range")
    attendances
  end

  def format_feedback_message(enrollment, missing_assignments, impressions, attendances)
    <<~MESSAGE
      Hello #{enrollment.user},

      **Feedback Report**
      Period: #{@start_date.strftime("%B %d")} - #{@end_date.strftime("%B %d")}

      **Missing Assignments:**
      #{missing_assignments.empty? ? "No missing assignments! 🎉" : missing_assignments.map { |a| "- #{a.name}" }.join("\n")}

      **Impressions:**
      #{impressions.empty? ? "No impressions recorded for this period." : impressions.map { |i| "- #{i.emoji} #{i.content}" }.join("\n")}

      **Attendance:**
      #{attendances.empty? ? "No attendance records for this period." : attendances.map { |a| "- #{a.title} (#{a.category.titleize})" }.join("\n")}
    MESSAGE
  end

  def create_report_record(enrollment, message)
    Rails.logger.info("[FeedbackReportService] Creating feedback report record for #{enrollment.user}")

    FeedbackReport.create!(
      enrollment: enrollment,
      canvas_gradebook_snapshot: @canvas_gradebook_snapshot,
      start_date: @start_date,
      end_date: @end_date,
      message: message
    )
  end

  def deliver_report(report, enrollment)
    Rails.logger.info("[FeedbackReportService] Attempting to send report to #{enrollment.user} (Discord ID: #{enrollment.user.discord_id})")

    if enrollment.user.discord_id.blank?
      error_message = "User #{enrollment.user} does not have a Discord ID set. Please set their Discord ID in the admin interface."
      Rails.logger.error("[FeedbackReportService] #{error_message}")
      report.mark_as_failed!(StandardError.new(error_message))
      return
    end

    @discord_service.send_dm(enrollment.user.discord_id, report.message)
    report.mark_as_sent!
    Rails.logger.info("[FeedbackReportService] Successfully sent report to #{enrollment.user}")
  rescue => e
    Rails.logger.error("[FeedbackReportService] Failed to send report to #{enrollment.user}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    report.mark_as_failed!(e)
    raise
  end
end
