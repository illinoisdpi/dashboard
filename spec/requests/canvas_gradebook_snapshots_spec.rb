require 'rails_helper'
require 'smarter_csv'

RSpec.describe CanvasGradebookSnapshot, type: :model do
  describe '#process_csv' do
    let!(:user) { create(:user) }
    let!(:cohort) { create(:cohort) }
    let(:csv_file_path) { Rails.root.join('spec/fixtures/Test-WE-2020-9.1-INTRO.csv') }
    let(:csv_file) { fixture_file_upload(csv_file_path, 'text/csv') }
    let(:snapshot) { build(:canvas_gradebook_snapshot, cohort: cohort, csv_file: csv_file, user: user) }

    let(:mock_csv_data) { SmarterCSV.process(csv_file_path) }

    before do
      allow(SmarterCSV).to receive(:process).and_return(mock_csv_data)
    end

    let(:expected_users_count) { mock_csv_data.map { |row| row[:sis_login_id] }.compact.uniq.count }
    let(:expected_assignments_count) { mock_csv_data.first.keys.count { |key| key.to_s.start_with?('assignment') } }
    let(:expected_submissions_count) { expected_users_count * expected_assignments_count }

    it 'saves the assignments, enrollments, and submissions correctly' do
      snapshot.save

      expect(CanvasAssignment.count).to eq(expected_assignments_count) 
      expect(User.count).to eq(expected_users_count)
      expect(CanvasSubmission.count).to eq(expected_submissions_count)
    end
  end
end
