namespace :dev do
  desc "drop and recreate db, create test cohort"
  task drop_and_add: :environment do
    commands = [
      "db:drop",
      "db:create",
      "db:migrate"
    ]

    commands.each { |command| Rake::Task[command].invoke }

    user = User.create(email: "alice@example.com", password: "password")
    user.add_role :admin
    user.save
    pp "user 'alice@example.com' created"

    cohort = Cohort.create(name: "Test Cohort", canvas_shortname: "test", year: 2024, generation: 1, number: 1, started_on: "2024-01-01")
    cohort.save
    pp "cohort '#{cohort.name}' created"

    30.times do
      first_name, last_name = Faker::Name.first_name, Faker::Name.last_name
      u = User.create(email: Faker::Internet.email, password: "password")
      u.update(first_name: , canvas_full: "#{last_name}, #{first_name}")
      u.enrollments.create(role: "student", cohort: cohort)
    end
    pp "30 students with empty first_name created"
    
    30.times do
      first_name, last_name = Faker::Name.first_name, Faker::Name.last_name
      u = User.create(email: Faker::Internet.email, password: "password")
      u.update(last_name: , canvas_full: "#{last_name}, #{first_name}")
      u.enrollments.create(role: "student", cohort: cohort)
    end
    pp "30 students with empty last_name created"
  end
end
