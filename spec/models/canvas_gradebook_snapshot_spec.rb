# == Schema Information
#
# Table name: canvas_gradebook_snapshots
#
#  id            :uuid             not null, primary key
#  csv_filename  :string
#  downloaded_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cohort_id     :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_canvas_gradebook_snapshots_on_cohort_id  (cohort_id)
#  index_canvas_gradebook_snapshots_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cohort_id => cohorts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe CanvasGradebookSnapshot, type: :model do
  let(:cohort) { create(:cohort, canvas_shortname: "WE-2022-1.2-SDF") }
  let(:user) { create(:user) }
  let(:valid_csv_path) { Rails.root.join('spec/fixtures/files/2022-01-01T1100_Grades-WE-2022-1.2-SDF.csv') }
  let(:csv_file) { fixture_file_upload(valid_csv_path, 'text/csv') }
  let(:snapshot) { build(:canvas_gradebook_snapshot, cohort: cohort, user: user, csv_file: csv_file) }

  describe '#process_csv' do
    context 'with valid CSV data' do
      before { snapshot.save! }

      it 'creates correct number of canvas assignments' do
        assignment_count = CSV.read(valid_csv_path)
                              .first
                              .drop(5)
                              .count { |h| h.match(/\(\d+\)/) }
        expect(CanvasAssignment.count).to eq(assignment_count)
      end

      it 'creates submissions with correct points from CSV' do
        csv_data = CSV.read(valid_csv_path)
        headers = csv_data[0]
        student_rows = csv_data[2..-1]

        # Select 5 random submissions to test
        submissions_to_test = CanvasSubmission.where(
          canvas_gradebook_snapshot: snapshot
        ).order("RANDOM()").limit(5)

        submissions_to_test.each do |submission|
          # Get related records
          enrollment = submission.enrollment
          user = enrollment.user
          assignment = submission.canvas_assignment

          # Find user's row
          user_row = student_rows.find { |row| row[3] == user.email }
          expect(user_row).to be_present, "No CSV row found for user #{user.email}"

          # Find assignment column in CSV
          assignment_column = headers.find_index do |header|
            header.match?(/\(#{assignment.id_from_canvas}\)/)
          end
          expect(assignment_column).to be_present, "No CSV column found for assignment #{assignment.id_from_canvas}"

          # Compare points
          csv_points = user_row[assignment_column].to_f
          csv_points = nil if user_row[assignment_column].blank?

          expect(submission.points).to eq(csv_points),
            "Mismatch for #{user.email} in #{headers[assignment_column]}. " \
            "Expected: #{csv_points || 'nil'}, Got: #{submission.points}"
        end
      end

      it 'creates correct number of users' do
        student_rows = CSV.read(valid_csv_path).drop(2)
        expect(Enrollment.where(role: :student).count).to eq(student_rows.count)
      end

      it 'creates enrollments for all users' do
        expect(Enrollment.count).to eq(User.count - 1) # subtracting 1 since an extra user exists to create snapshot
        expect(Enrollment.pluck(:cohort_id).uniq).to eq([ cohort.id ])
      end

      it 'correctly parses downloaded_at from filename' do
        expect(snapshot.downloaded_at).to eq(DateTime.new(2022, 1, 1, 11, 0))
      end
    end
  end
end
