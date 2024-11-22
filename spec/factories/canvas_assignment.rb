FactoryBot.define do
    factory :canvas_assignment do
        id_from_canvas { Faker::Number.number(digits: 5) }
        name { Faker::Educator.course_name }
        points_possible { Faker::Number.number(digits: 2) }
        cohort
    end
  end
  