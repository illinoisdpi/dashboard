# spec/models/canvas_gradebook_snapshot_spec.rb
require 'rails_helper'

RSpec.describe CanvasGradebookSnapshot::Csvable, type: :model do
  include ActionDispatch::TestProcess

  describe 'process_csv' do
    let(:cohort) { create(:cohort, canvas_shortname: 'WE-2022-1.2-SDF') }
    let(:csv_file_path) { Rails.root.join('tmp', '2022-01-01T1100_Grades-WE-2022-1.2-SDF.csv') }
    let(:csv_file) { Rack::Test::UploadedFile.new(csv_file_path, 'text/csv') }
    let(:snapshot_user) { create(:user) }
    let(:csv_snapshot) { build(:canvas_gradebook_snapshot, cohort: cohort, csv_file: csv_file) }

    after do
      File.delete(csv_file_path) if File.exist?(csv_file_path)
    end

    context 'when processing a CSV with new users and enrollments' do
      before do
        csv_data = <<~CSV
          Student,ID,SIS User ID,SIS Login ID,Section,Assignment 1_12345,Assignment 2_23456
          Points Possible,,,,,100,50
          "Doe, John",,,"john.doe@example.com",Section A,85,45
          "Smith, Jane",,,"jane.smith@example.com",Section A,90,50
        CSV
        File.open(csv_file_path, 'w') { |f| f.write(csv_data) }
      end

      it 'creates new users, enrollments, assignments, and submissions' do
        expect { csv_snapshot.save! }
          .to change(User, :count).by(3)
          .and change(Enrollment, :count).by(2)
          .and change(CanvasAssignment, :count).by(2)
          .and change(CanvasSubmission, :count).by(4)

        # Verify users
        user1 = User.find_by(email: 'john.doe@example.com')
        user2 = User.find_by(email: 'jane.smith@example.com')
        expect(user1.first_name).to eq('John')
        expect(user2.last_name).to eq('Smith')

        # Verify assignments
        assignment1 = CanvasAssignment.find_by(id_from_canvas: '12345')
        assignment2 = CanvasAssignment.find_by(id_from_canvas: '23456')
        expect(assignment1.name).to eq('assignment 1')
        expect(assignment2.points_possible).to eq(50)

        # Verify enrollments
        enrollment1 = Enrollment.find_by(user: user1, cohort: cohort)
        enrollment2 = Enrollment.find_by(user: user2, cohort: cohort)
        expect(enrollment1.role).to eq('student')

        # Verify submissions
        submission = CanvasSubmission.find_by(enrollment: enrollment1, canvas_assignment: assignment1)
        expect(submission.points).to eq(85)
      end
    end

    context 'when processing a CSV with existing users and enrollments' do
      let!(:existing_user) { create(:user, email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe') }
      let!(:existing_enrollment) { create(:enrollment, user: existing_user, cohort: cohort, role: 'student') }

      before do
        csv_data = <<~CSV
          Student,ID,SIS User ID,SIS Login ID,Section,Assignment 1_12345
          Points Possible,,,,,100
          "Doe, John",,,"john.doe@example.com",Section A,85
        CSV
        File.open(csv_file_path, 'w') { |f| f.write(csv_data) }
      end

      it 'does not overwrite existing users or enrollments' do
        expect { csv_snapshot.save! }
          .to change(User, :count).by(1)
          .and change(Enrollment, :count).by(0)
          .and change(CanvasAssignment, :count).by(1)
          .and change(CanvasSubmission, :count).by(1)

        user = User.find_by(email: 'john.doe@example.com')
        expect(user.first_name).to eq('John') # Ensures name hasn't changed

        enrollment = Enrollment.find_by(user: user, cohort: cohort)
        expect(enrollment.role).to eq('student')
      end
    end

    context 'when processing a CSV with existing assignments' do
      let!(:existing_assignment) do
        create(:canvas_assignment, cohort: cohort, id_from_canvas: '12345', name: 'Assignment 1', points_possible: 100)
      end

      before do
        csv_data = <<~CSV
          Student,ID,SIS User ID,SIS Login ID,Section,Assignment 1_12345
          Points Possible,,,,,100
          "Doe, John",,,"john.doe@example.com",Section A,85
        CSV
        File.open(csv_file_path, 'w') { |f| f.write(csv_data) }
      end

      it 'does not duplicate existing assignments' do
        expect { csv_snapshot.save! }
          .to change(CanvasAssignment, :count).by(0)
          .and change(CanvasSubmission, :count).by(1)
      end
    end

    context 'when CSV filename does not contain the cohort canvas_shortname' do
      let(:csv_file_path) { Rails.root.join('tmp', '2022-01-01T1100_Grades-OTHER-COHORT.csv') }

      before do
        csv_data = <<~CSV
          Student,ID,SIS User ID,SIS Login ID,Section,Assignment 1_12345
          Points Possible,,,,,100
          "Doe, John",,,"john.doe@example.com",Section A,85
        CSV
        File.open(csv_file_path, 'w') { |f| f.write(csv_data) }
      end

      it 'is invalid and does not process the CSV' do
        expect(csv_snapshot).not_to be_valid
        expect(csv_snapshot.errors[:csv_filename]).to include("must contain canvas shortname belonging to this cohort")
      end
    end
  end
end
