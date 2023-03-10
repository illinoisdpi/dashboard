namespace :ingest do
  desc "Ingest Piazza Activity Download CSV file"
  task piazza_activity_download: :environment do
    cohort = Cohort.find_by(year: 2023, generation: 1, number: 1)

    ap cohort.errors.full_messages if cohort.errors.any?

    piazza_activity_download = PiazzaActivityDownload.create(
      activity_from: "06-Feb-2023",
      activity_until: "13-Feb-2023",
      cohort:
    )

    ap piazza_activity_download.errors.full_messages if piazza_activity_download.errors.any?

    if piazza_activity_download.persisted?
      require "csv"

      # filename = Rails.root.join("lib", "data", "piazza_activity_downloads", "2023-01-30_2023-02-06_piazza-we_2023_1_1-stats_summary-2023-03-10.csv")
      filename = Rails.root.join("lib", "data", "piazza_activity_downloads", "2023-02-06_2023-02-13_piazza-we_2023_1_1-stats_summary-2023-03-10.csv")

      options = {key_mapping: {"live_q&a_upvotes": :live_qa_upvotes}}

      csv = SmarterCSV.process(filename, options)

      csv.each do |row|
        emails = row.fetch(:emails).split(";").map(&:strip)
        ap emails

        user = User.where(email: emails).first
        ap user
        
        if user.blank?
          user = User.new(email: emails.first, password: SecureRandom.hex(16))       
        end

        user.piazza_full = row.fetch(:name, "None provided")
        user.save

        ap user.errors.full_messages if user.errors.any?

        ap user

        enrollment = Enrollment.find_or_create_by(user: user, cohort: cohort) do |the_enrollment|
          the_enrollment.role = row.fetch(:role)
        end

        piazza_activity_breakdown = piazza_activity_download.
          piazza_activity_breakdowns.
          create(enrollment:, **row)
      end
    end

    puts "There are now #{Cohort.count} rows in the Cohort table"
    puts "There are now #{User.count} rows in the User table"
    puts "There are now #{PiazzaActivityDownload.count} rows in the PiazzaActivityDownload table"
    puts "There are now #{PiazzaActivityBreakdown.count} rows in the PiazzaActivityBreakdown table"
  
  end
end
