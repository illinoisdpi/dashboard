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
        #TODO: Fix this so that it also ignores columns with no submissions
        # assignment_count = CSV.read(valid_csv_path)[0][5..-1].count { |h| h.match(/\(\d+\)/) } 
        expect(snapshot.canvas_assignments.count).to eq(18)
      end

      it 'creates assignments with correct points possible' do
        points_possible_row = CSV.read(valid_csv_path)[1]
        assignment = snapshot.canvas_assignments.find_by(id_from_canvas: '1233')
        expected_points = points_possible_row[6].to_f
        expect(assignment.points_possible).to eq(expected_points)
      end

      it 'creates correct number of users' do
        student_rows = CSV.read(valid_csv_path).drop(2)
        expect(Enrollment.where(role: :student).count).to eq(student_rows.count)
      end

      it 'creates enrollments for all users' do
        expect(Enrollment.count).to eq(User.count - 1) #Subtracting 1 since an extra user exists to create snapshot
        expect(Enrollment.pluck(:cohort_id).uniq).to eq([cohort.id])
      end

      it 'creates submissions with correct points' do
        assignment = CanvasAssignment.find_by(id_from_canvas: '1233')
        submission = CanvasSubmission.joins(:enrollment)
                                     .where(enrollment: { user: User.find_by(email: 'jeff@morar.io') })
                                     .find_by(canvas_assignment: assignment)
        expect(submission.points).to eq(5.0)
      end

      it 'correctly parses downloaded_at from filename' do
        expect(snapshot.downloaded_at).to eq(DateTime.new(2022, 1, 1, 11, 0))
      end
    end
  end
end