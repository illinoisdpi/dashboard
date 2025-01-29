FactoryBot.define do
    factory :canvas_submission do
      enrollment
      canvas_assignment
      points { 90 }
      canvas_gradebook_snapshot
    end
  end