require 'rails_helper'

RSpec.describe CanvasGradebookSnapshot::Csvable, type: :model do
  let(:cohort) { create(:cohort, canvas_shortname: 'WE-2022-1.2-SDF') }
  let(:csv_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/2022-01-01T1100_Grades-WE-2022-1.2-SDF.csv'), 'text/csv') }
  let(:csv_snapshot) { create(:canvas_gradebook_snapshot, cohort: cohort, csv_file: csv_file) }

  before do
    CanvasAssignment.delete_all
    User.delete_all
    Enrollment.delete_all
    CanvasSubmission.delete_all
  end

  it 'creates assignments, users, enrollments, and submissions' do
    expect { csv_snapshot.send(:process_csv) }
      .to change(CanvasAssignment, :count).by(92)
      .and change(User, :count).by(37)
      .and change(Enrollment, :count).by(36)
      .and change(CanvasSubmission, :count).by(245)
  end
end
