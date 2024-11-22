FactoryBot.define do
    factory :enrollment do
        user
        cohort
        role { "student" }
    end
end