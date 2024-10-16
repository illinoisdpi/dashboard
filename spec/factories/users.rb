FactoryBot.define do
    factory :user do
      email { Faker::Internet.unique.email }
      password { "password" }
      first_name { "John" }
      last_name { "Doe" }
    end
  end
  