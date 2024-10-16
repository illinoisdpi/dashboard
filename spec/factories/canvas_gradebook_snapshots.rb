FactoryBot.define do
    factory :canvas_gradebook_snapshot do
      csv_filename { "test.csv" }
      downloaded_at { DateTime.now }
      association :cohort
      association :user
    end
  end
  