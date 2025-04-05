class FeedbackReportService
  def initialize(canvas_gradebook_snapshot, start_date, end_date, assignment_ids)
    @canvas_gradebook_snapshot = canvas_gradebook_snapshot
    @cohort = canvas_gradebook_snapshot.cohort
    @start_date = start_date
    @end_date = end_date
    @assignment_ids = assignment_ids
    @discord_service = DiscordService.new(@cohort)
  end

  def generate_report_for_enrollment(enrollment)
    Rails.logger.info("FeedbackReportService: Generating report for enrollment #{enrollment.id} (#{enrollment.user})")

    # Get the selected assignments for the report
    selected_assignments = @canvas_gradebook_snapshot.canvas_assignments
      .where(id: @assignment_ids)
      .index_by(&:id)

    Rails.logger.info("FeedbackReportService: Found #{selected_assignments.size} assignments")

    generate_report(enrollment, selected_assignments)
  end

  def generate_and_send_reports
    selected_assignments = @canvas_gradebook_snapshot.canvas_assignments
      .where(id: @assignment_ids)
      .index_by(&:id)

    @cohort.enrollments.student.each do |enrollment|
      next unless enrollment.user.discord_id

      report = generate_report(enrollment, selected_assignments)
      send_report(report, enrollment)
    end
  end

  def generate_and_send_report_for_enrollment(enrollment)
    # First generate the report
    report = generate_report_for_enrollment(enrollment)

    # Then send it via Discord
    send_report(report, enrollment)

    report
  end

  private

  def generate_report(enrollment, selected_assignments)
    Rails.logger.info("FeedbackReportService: Processing report for #{enrollment.user} with #{selected_assignments.size} assignments")

    user_submissions = @canvas_gradebook_snapshot.canvas_submissions
      .where(enrollment: enrollment)
      .where(canvas_assignment_id: @assignment_ids)
      .index_by(&:canvas_assignment_id)

    Rails.logger.info("FeedbackReportService: Found #{user_submissions.size} submissions")

    missing_assignments = selected_assignments.values.reject do |assignment|
      user_submissions.key?(assignment.id)
    end

    Rails.logger.info("FeedbackReportService: Found #{missing_assignments.size} missing assignments")

    impressions = enrollment.impressions
      .where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
      .where(staff_only: false)
      .order(created_at: :desc)

    Rails.logger.info("FeedbackReportService: Found #{impressions.size} impressions for date range #{@start_date} to #{@end_date}")

    attendances = enrollment.attendances
      .where(occurred_at: @start_date.beginning_of_day..@end_date.end_of_day)
      .includes(:attendees)
      .order(occurred_at: :desc)

    Rails.logger.info("FeedbackReportService: Found #{attendances.size} attendances for date range")

    message = <<~MESSAGE
      **Progress Feedback Report**
      Period: #{@start_date.strftime("%B %d")} - #{@end_date.strftime("%B %d")}

      **Missing Assignments:**
      #{missing_assignments.empty? ? "No missing assignments! 🎉" : missing_assignments.map { |a| "- #{a.name}" }.join("\n")}

      **Impressions:**
      #{impressions.empty? ? "No impressions recorded for this period." : impressions.map { |i| "- #{i.emoji} #{i.content}" }.join("\n")}

      **Attendance:**
      #{attendances.empty? ? "No attendance records for this period." : attendances.map { |a| "- #{a.title} (#{a.category.titleize})" }.join("\n")}
    MESSAGE

    Rails.logger.info("FeedbackReportService: Creating feedback report record for #{enrollment.user}")

    FeedbackReport.create!(
      enrollment: enrollment,
      canvas_gradebook_snapshot: @canvas_gradebook_snapshot,
      start_date: @start_date,
      end_date: @end_date,
      message: message
    )
  end

  def send_report(report, enrollment)
    @discord_service.send_dm(enrollment.user.discord_id, report.message)
    report.mark_as_sent!
  rescue => e
    report.mark_as_failed!(e)
    raise e
  end
end
