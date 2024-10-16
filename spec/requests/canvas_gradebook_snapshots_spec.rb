require 'rails_helper'

RSpec.describe CanvasGradebookSnapshot, type: :model do
  describe '#process_csv' do
    let(:cohort) { create(:cohort) }
    let(:csv_file) { fixture_file_upload('spec/fixtures/Test-WE-2020-9.1-INTRO.csv', 'text/csv') }
    let(:snapshot) { build(:canvas_gradebook_snapshot, cohort: cohort, csv_file: csv_file) }

    before do
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
