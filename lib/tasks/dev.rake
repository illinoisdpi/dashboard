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

      users = []

      usernames.each do |username|
        users << User.create(
          email: "#{username}@example.com",
          password: "password"
        )
      end

      cohort = Cohort.create(
        year: 2022,
        generation: 1,
        number: 2,
        name: "Sample Cohort",
        canvas_shortname: "WE-2022-1.2-SDF"
      )

      if cohort.errors.any?
        ap cohort.errors.full_messages
        ap cohort
      end

      sample_cohort_enrollment_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: Rails.root.join("lib", "sample_data", "sample-cohort-enrollment.csv").open,
        filename: "sample-cohort-enrollment.csv",
        type: "text/plain"
      )
      sample_cohort_enrollment_csv = SmarterCSV.process(sample_cohort_enrollment_file)
      sample_cohort_enrollment_csv.each do |row|
        user = User.create(email: row.fetch(:email), canvas_full: row.fetch(:name), password: "password")
        cohort.enrollments.create(user:, id_from_canvas: row.fetch(:id_from_canvas), role: row.fetch(:role))
      end

      cohort_start_date = Date.parse("2023-01-30")

      6.times do |i|
        uploaded_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: Rails.root.join("lib", "sample_data", "piazza-activity-#{i}.csv").open,
          filename: "piazza-activity-#{i}.csv",
          type: "text/plain"
        )

        cohort.piazza_activity_reports.create(
          activity_from: cohort_start_date + i.weeks,
          activity_until: cohort_start_date + (i + 1).weeks,
          csv_file: uploaded_file,
          user: users.sample
        )
      end

      1.upto(4) do |i|
        filename = "2022-0#{i}-01T1#{i}00_Grades-WE-2022-1.2-SDF.csv"
        csv_file = ActionDispatch::Http::UploadedFile.new(
          tempfile: Rails.root.join("lib", "sample_data", filename).open,
          type: "text/plain",
          filename:
        )

        cohort.canvas_gradebook_snapshots.create(
          downloaded_at: cohort_start_date + (i + 1).weeks,
          user: users.sample,
          csv_file:,
        )
      end
    end
  end
end
