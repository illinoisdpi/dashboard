FactoryBot.define do
    factory :enrollment do
      cohort
      user
      role { "student" }
      sequence(:id_from_canvas) { |n| n }
    end
  end