class Cohort::FeedbackReportsController < ApplicationController
  before_action :set_cohort
  before_action :set_enrollment, except: [ :batch_create, :index, :show, :new, :create, :send_report, :send_all ]
  before_action { authorize(FeedbackReport) }

  def index
    @feedback_reports = policy_scope(@cohort.feedback_reports)
      .order(created_at: :desc)
      .includes(enrollment: :user)
  end

  def show
    @feedback_report = @cohort.feedback_reports.find(params[:id])
    authorize @feedback_report
  end

  def new
    @feedback_report = FeedbackReport.new
  end

  def batch_create
    if policy(FeedbackReport).create?
      begin
        canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:canvas_gradebook_snapshot_id])
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        assignments = params[:assignments]

        Rails.logger.info("Starting batch feedback report generation")
        Rails.logger.info("Parameters: start_date=#{start_date}, end_date=#{end_date}, assignments=#{assignments.inspect}")

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

        service = FeedbackReportService.new(
          canvas_gradebook_snapshot,
          start_date,
          end_date,
          assignments
        )

        success_count = 0
        error_count = 0
        error_messages = []

        student_enrollments = @cohort.enrollments.student
        total_students = student_enrollments.count
        Rails.logger.info("Processing #{total_students} student enrollments")

        student_enrollments.each do |enrollment|
          Rails.logger.info("Processing student: #{enrollment.user} (#{enrollment.id})")

          begin
            Rails.logger.info("Generating report for #{enrollment.user}")
            service.create_feedback_report(enrollment)
            success_count += 1
            Rails.logger.info("Successfully generated report for #{enrollment.user}")
          rescue => e
            error_count += 1
            error_message = "Error generating report for #{enrollment.user}: #{e.message}"
            error_messages << error_message
            Rails.logger.error(error_message)
            Rails.logger.error(e.backtrace.join("\n"))
          end
        end

        message = "Generated #{success_count} feedback reports"
        if error_count > 0
          message += " with #{error_count} errors:\n#{error_messages.join("\n")}"
        end

        Rails.logger.info(message)

        redirect_to cohort_feedback_reports_path(@cohort), notice: message
      rescue => e
        Rails.logger.error("Fatal error in batch_create: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        redirect_to cohort_feedback_reports_path(@cohort), alert: "Error generating reports: #{e.message}\n#{e.backtrace.first}"
      end
    else
      redirect_to cohort_feedback_reports_path(@cohort), alert: "You are not authorized to generate feedback reports."
    end
  end

  def create
    if policy(FeedbackReport).create?
      canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.find(params[:feedback_report][:canvas_gradebook_snapshot_id])
      start_date = Date.parse(params[:feedback_report][:start_date])
      end_date = Date.parse(params[:feedback_report][:end_date])
      assignments = params[:feedback_report][:assignments].split(",").map(&:strip)

      Rails.logger.info("Starting batch feedback report generation")
      Rails.logger.info("Parameters: start_date=#{start_date}, end_date=#{end_date}, assignments=#{assignments.inspect}")

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

      service = FeedbackReportService.new(
        canvas_gradebook_snapshot,
        start_date,
        end_date,
        assignments
      )
      success_count = 0
      error_count = 0

      student_enrollments = @cohort.enrollments.student
      total_students = student_enrollments.count
      Rails.logger.info("Processing #{total_students} student enrollments")

      student_enrollments.each do |enrollment|
        Rails.logger.info("Processing student: #{enrollment.user} (#{enrollment.id})")

        begin
          Rails.logger.info("Generating report for #{enrollment.user}")
          service.process_feedback_report(enrollment, send_to_discord: false)
          success_count += 1
          Rails.logger.info("Successfully generated report for #{enrollment.user}")
        rescue => e
          error_count += 1
          Rails.logger.error("Error generating report for #{enrollment.user}: #{e.message}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
      end

      message = "Generated #{success_count} feedback reports"
      message += " with #{error_count} errors" if error_count > 0

      Rails.logger.info(message)

      redirect_to cohort_feedback_reports_path(@cohort), notice: message
    else
      redirect_to cohort_feedback_reports_path(@cohort), alert: "You are not authorized to generate feedback reports."
    end
  rescue => e
    Rails.logger.error("Fatal error in create: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    redirect_to cohort_feedback_reports_path(@cohort), alert: "Error generating reports: #{e.message}"
  end

  def send_report
    @feedback_report = @cohort.feedback_reports.find(params[:id])
    Rails.logger.info("[FeedbackReportsController] Sending report #{@feedback_report.id} for #{@feedback_report.enrollment.user}")

    service = FeedbackReportService.new(
      @feedback_report.canvas_gradebook_snapshot,
      @feedback_report.start_date,
      @feedback_report.end_date,
      @feedback_report.canvas_gradebook_snapshot.canvas_assignments.pluck(:id)
    )
    service.send_feedback_report(@feedback_report, @feedback_report.enrollment)

    redirect_to cohort_feedback_report_path(@cohort, @feedback_report), notice: "Feedback report was successfully sent."
  rescue => e
    Rails.logger.error("[FeedbackReportsController] Failed to send report #{@feedback_report.id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    redirect_to cohort_feedback_report_path(@cohort, @feedback_report), alert: "Failed to send feedback report: #{e.message}"
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
end
