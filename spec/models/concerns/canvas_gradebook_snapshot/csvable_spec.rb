require 'rails_helper'
require 'csv'

RSpec.describe CanvasGradebookSnapshot::Csvable, type: :model do
  let(:cohort) do
    Cohort.create(
      year: 2020,
      generation: 9,
      number: 1,
      name: "WE-2020-9.1-Intro",
      canvas_shortname: 'WE-2020-9.1-Intro',
      started_on: "2020-09-19"
    )
  end

  let(:csv_file) do
    file_path = Rails.root.join('lib', 'sample_data', 'Test-WE-2020-9.1-INTRO.csv')
    ActionDispatch::Http::UploadedFile.new(
      tempfile: File.open(file_path),
      filename: 'Test-WE-2020-9.1-INTRO.csv',
      type: 'text/csv'
    )
  end

  let(:canvas_gradebook_snapshot) do
    cohort.canvas_gradebook_snapshots.create(csv_file: csv_file)
  end

  before do
    Rails.logger.info "Starting CSV processing for cohort: #{cohort.name}"
    canvas_gradebook_snapshot.send(:process_csv)
    Rails.logger.info "Finished CSV processing for cohort: #{cohort.name}"
  end

  it 'verifies that assignment scores for randomly selected users match the CSV data' do
    random_users = cohort.users.sample(3)
    Rails.logger.info "Randomly selected users for verification: #{random_users.map(&:email).join(', ')}"

    random_users.each do |user|
      csv_row = find_csv_row_for_user(user.email)

      if csv_row.nil?
        Rails.logger.error "No CSV row found for user with email: #{user.email}"
      else
        Rails.logger.info "Verifying data for user: #{user.email}"

        csv_row.each do |assignment_name_raw, points|
          next unless points.is_a?(Numeric) && points > 0

          assignment_id = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
          assignment = cohort.canvas_assignments.find_by(id_from_canvas: assignment_id)

          if assignment.nil?
            Rails.logger.error "Assignment with ID #{assignment_id} not found for user #{user.email}"
          else
            Rails.logger.info "Found assignment: #{assignment.name} (ID: #{assignment_id}) for user #{user.email}"
          end

          submission = CanvasSubmission.find_by(enrollment_id: user.enrollments.first.id, canvas_assignment_id: assignment.id)
          expect(submission).not_to be_nil, "Submission for assignment #{assignment&.name} and user #{user.email} should have been created."
          expect(submission.points).to eq(points.to_f), "Submission points for assignment #{assignment&.name} and user #{user.email} should match the CSV."
        end
      end
    end
  end

  after do
    Rails.logger.info "Cleaning up test data by destroying cohort: #{cohort.name}"
    cohort.destroy
    Rails.logger.info "Cohort #{cohort.name} and associated data have been destroyed."
  end

  private

  def find_csv_row_for_user(email)
    file_path = Rails.root.join('lib', 'sample_data', 'Test-WE-2020-9.1-INTRO.csv')
    csv_content = CSV.read(file_path, headers: true)

    csv_row = csv_content.find { |row| row['SIS Login ID'] == email }
    Rails.logger.info csv_row.nil? ? "No CSV data found for user with email: #{email}" : "CSV data found for user with email: #{email}"
    csv_row
  end
end
