require 'rails_helper'
require 'smarter_csv'

RSpec.describe CanvasGradebookSnapshot, type: :model do
  describe '#process_csv' do
    let(:cohort) { create(:cohort) }
    let(:csv_file_path) { Rails.root.join('spec/fixtures/Test-WE-2020-9.1-INTRO.csv') }
    let(:csv_file) { fixture_file_upload(csv_file_path, 'text/csv') }
    let(:snapshot) { build(:canvas_gradebook_snapshot, cohort: cohort, csv_file: csv_file) }

    # Process the CSV file to use its actual data
    let(:mock_csv_data) { SmarterCSV.process(csv_file_path) }

    before do
      # Mock SmarterCSV's behavior with the actual data from the CSV
      allow(SmarterCSV).to receive(:process).and_return(mock_csv_data)
    end

    it 'saves the assignments, users, and submissions correctly' do
      snapshot.save

      expect(CanvasAssignment.count).to eq(expected_assignments_count)
      expect(User.count).to eq(expected_users_count)
      expect(CanvasSubmission.count).to eq(expected_submissions_count)
    end
  end
end
