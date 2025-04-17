module FeedbackReport::Creation
  extend ActiveSupport::Concern

  class_methods do
    def batch_create(cohort, canvas_gradebook_snapshot, start_date, end_date, assignments)
      begin
        Rails.logger.info("Starting batch feedback report generation")

        service = FeedbackReportService.new(canvas_gradebook_snapshot, start_date, end_date, assignments)

        success_count = 0
        error_count = 0
        error_messages = []

        process_student_enrollments(cohort) do |enrollment|
          begin
            service.create_feedback_report(enrollment)
            success_count += 1
          rescue => e
            error_count += 1
            error_message = "Error generating report for #{enrollment.user}: #{e.message}"
            error_messages << error_message
          end
        end

        message = "Generated #{success_count} feedback reports"
        if error_count > 0
          message += " with #{error_count} errors:\n#{error_messages.join("\n")}"
        end

        [ true, {
          success_count: success_count,
          error_count: error_count,
          error_messages: error_messages,
          message: message
        } ]
      rescue => e
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
        end
      end
      deleted_count
    end

    def process_student_enrollments(cohort)
      student_enrollments = cohort.enrollments.student

      student_enrollments.each do |enrollment|
        yield enrollment
      end
    end
  end
end
