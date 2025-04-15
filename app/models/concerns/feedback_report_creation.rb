module FeedbackReportCreation
  extend ActiveSupport::Concern

  class_methods do
    def batch_create(cohort, canvas_gradebook_snapshot, start_date, end_date, assignments)
      begin
        Rails.logger.info("Starting batch feedback report generation")
        Rails.logger.info("Parameters: start_date=#{start_date}, end_date=#{end_date}, assignments=#{assignments.inspect}")

        deleted_count = delete_existing_reports(cohort, canvas_gradebook_snapshot, start_date, end_date)
        Rails.logger.info("Deleted #{deleted_count} existing reports to avoid uniqueness constraints")

        service = FeedbackReportService.new(canvas_gradebook_snapshot, start_date, end_date, assignments)

        success_count = 0
        error_count = 0
        error_messages = []

        process_student_enrollments(cohort) do |enrollment|
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

        [ true, {
          success_count: success_count,
          error_count: error_count,
          error_messages: error_messages,
          message: message
        } ]
      rescue => e
        Rails.logger.error("Fatal error in batch_create: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        [ false, {
          error: e.message,
          backtrace: e.backtrace.first
        } ]
      end
    end

    private

    def delete_existing_reports(cohort, canvas_gradebook_snapshot, start_date, end_date)
      deleted_count = 0
      cohort.enrollments.student.each do |enrollment|
        existing_reports = where(
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
      deleted_count
    end

    def process_student_enrollments(cohort)
      student_enrollments = cohort.enrollments.student
      total_students = student_enrollments.count
      Rails.logger.info("Processing #{total_students} student enrollments")

      student_enrollments.each do |enrollment|
        yield enrollment
      end
    end
  end
end
