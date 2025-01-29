FactoryBot.define do
    factory :canvas_assignment do
      cohort
      sequence(:id_from_canvas) { |n| n }
      name { "Assignment #{id_from_canvas}" }
      points_possible { 100 }
    end
  end