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
FactoryBot.define do
  factory :canvas_gradebook_snapshot do
    cohort
    csv_file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/2022-01-01T1100_Grades-WE-2022-1.2-SDF.csv'), 'text/csv') }
  end
end
