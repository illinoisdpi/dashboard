class Cohort::FeedbackReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment, except: [ :batch_create ]
  before_action { authorize(FeedbackReport) }

  def show
    @feedback_report = @enrollment.feedback_reports.find(params[:id])
    authorize @feedback_report
  end

  def create
    if policy(FeedbackReport).create?
      canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      assignments = params[:assignments]

      # Handle "all" enrollment ID
      if params[:enrollment_id] == "all"
        return batch_create
      end

      service = FeedbackReportService.new(
        canvas_gradebook_snapshot,
        start_date,
        end_date,
        assignments
      )

      # Generate the report using the service's public method and send it via Discord
      service.generate_and_send_report_for_enrollment(@enrollment)

      redirect_to cohort_enrollment_path(@cohort, @enrollment),
                  notice: "Feedback report generated and sent via Discord successfully!"
    else
      redirect_to cohort_enrollment_path(@cohort, @enrollment),
                  alert: "You are not authorized to generate feedback reports."
    end
  rescue => e
    redirect_to cohort_enrollment_path(@cohort, @enrollment),
                alert: "Error generating report: #{e.message}"
  end

  def batch_create
    if policy(FeedbackReport).create?
      canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      assignments = params[:assignments]

      Rails.logger.info("Starting batch feedback report generation")
      Rails.logger.info("Parameters: start_date=#{start_date}, end_date=#{end_date}, assignments=#{assignments.inspect}")

      # First, delete any existing reports for this date range if they exist
      # This avoids uniqueness constraint issues
      deleted_count = 0
      @cohort.enrollments.student.each do |enrollment|
        existing_reports = FeedbackReport.where(
          enrollment: enrollment,
          canvas_gradebook_snapshot: canvas_gradebook_snapshot,
          start_date: start_date,
          end_date: end_date
        )

        if existing_reports.any?
          deleted_count += existing_reports.count
          existing_reports.destroy_all
          Rails.logger.info("Deleted #{existing_reports.count} existing reports for #{enrollment.user}")
        end
      end

      Rails.logger.info("Deleted #{deleted_count} existing reports to avoid uniqueness constraints")

      # Initialize the service once
      service = FeedbackReportService.new(
        canvas_gradebook_snapshot,
        start_date,
        end_date,
        assignments
      )

      # Generate reports for all students
      success_count = 0
      error_count = 0
      missing_discord_count = 0

      # Log the total number of student enrollments
      student_enrollments = @cohort.enrollments.student
      total_students = student_enrollments.count
      Rails.logger.info("Processing #{total_students} student enrollments")

      student_enrollments.each do |enrollment|
        Rails.logger.info("Processing student: #{enrollment.user} (#{enrollment.id})")

        unless enrollment.user.discord_id.present?
          Rails.logger.info("Skipping student #{enrollment.user} - no Discord ID")
          missing_discord_count += 1
          next
        end

        begin
          # Generate the report using the service's public method and send it via Discord
          Rails.logger.info("Generating and sending report for #{enrollment.user}")
          service.generate_and_send_report_for_enrollment(enrollment)
          success_count += 1
          Rails.logger.info("Successfully generated and sent report for #{enrollment.user}")
        rescue => e
          error_count += 1
          Rails.logger.error("Error generating report for #{enrollment.user}: #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
      end

      message = "Generated and sent #{success_count} feedback reports via Discord"
      message += " with #{error_count} errors" if error_count > 0
      message += ". #{missing_discord_count} students skipped (no Discord ID)" if missing_discord_count > 0

      Rails.logger.info(message)

      redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, canvas_gradebook_snapshot),
                  notice: message
    else
      redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, canvas_gradebook_snapshot),
                  alert: "You are not authorized to generate feedback reports."
    end
  rescue => e
    Rails.logger.error("Fatal error in batch_create: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, canvas_gradebook_snapshot),
                alert: "Error generating reports: #{e.message}"
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_enrollment
    @enrollment = @cohort.enrollments.find(params[:enrollment_id])
  end
end
