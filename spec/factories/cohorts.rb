FactoryBot.define do
  factory :cohort do
    canvas_shortname { "Test-WE-2020-9.1-INTRO" }
    year { 2020 }
    generation { 9 }
    number { 1 }
    started_on { Date.today }
  end
end
