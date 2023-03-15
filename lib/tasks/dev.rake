namespace :dev do
  desc "Destroy, re-create, re-seed, and re-prime the database"
  task reprime: [
    :environment,
    "db:drop",
    "db:create",
    "db:migrate",
    "db:seed",
    "dev:prime"
  ]

  desc "Hydrate the database with sample data"
  task prime: :environment do
    Time.use_zone("America/Chicago") do
      usernames = %w[alice bob carol]

      usernames.each do |username|
        User.create(
          email: "#{username}@example.com",
          password: "password"
        )
      end

      cohort = Cohort.create(
        year: 2022,
        generation: 1,
        number: 2,
        name: "Sample Cohort"
      )

      if cohort.errors.any?
        ap cohort.errors.full_messages
        ap cohort
      end

      cohort_start_date = Date.parse("2023-01-30")

      6.times do |i|
        uploaded_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: File.open(Rails.root.join("lib", "sample_data", "piazza-activity-#{i}.csv")),
          filename: "piazza-activity-#{i}.csv",
          type: 'text/plain'
        )

        cohort.piazza_activity_downloads.create(
          activity_from: cohort_start_date + i.weeks,
          activity_until: cohort_start_date + (i + 1).weeks,
          csv_file: uploaded_file
        )
      end
    end
  end
end
