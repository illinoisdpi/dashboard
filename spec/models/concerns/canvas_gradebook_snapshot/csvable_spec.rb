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
    # Step 3: Populate Cohort using `process_csv` with the CSV file
    canvas_gradebook_snapshot.send(:process_csv)
  end

  it 'verifies that assignment scores for randomly selected users match the CSV data' do
    # Step 4: Grab 3 random users belonging to that cohort
    random_users = cohort.users.sample(3)

    random_users.each do |user|
      # Step 5: Look through their assignment scores and make sure it matches with the CSV
      csv_row = find_csv_row_for_user(user.email)

      csv_row.each do |assignment_name_raw, points|
        next unless points.is_a?(Numeric) && points > 0

        assignment_id = CanvasGradebookSnapshot.extract_id_from_canvas(assignment_name_raw)
        assignment = cohort.canvas_assignments.find_by(id_from_canvas: assignment_id)

        expect(assignment).not_to be_nil, "Assignment with ID #{assignment_id} should have been created."
        
        submission = CanvasSubmission.find_by(enrollment_id: user.enrollments.first.id, canvas_assignment_id: assignment.id)
        expect(submission).not_to be_nil, "Submission for assignment #{assignment.name} and user #{user.email} should have been created."
        expect(submission.points).to eq(points.to_f), "Submission points for assignment #{assignment.name} and user #{user.email} should match the CSV."
      end
    end
  end

  after do
    # Step 6: Drop the cohort
    cohort.destroy
  end

  private

  # Helper method to find the corresponding CSV row for the user
  def find_csv_row_for_user(email)
    file_path = Rails.root.join('lib', 'sample_data', 'Test-WE-2020-9.1-INTRO.csv')
    csv_content = CSV.read(file_path, headers: true)

    csv_content.find { |row| row['SIS Login ID'] == email }
  end
end
