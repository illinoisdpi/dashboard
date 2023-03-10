namespace :ingest do
  desc "Ingest Piazza Activity Download CSV file"
  task piazza_activity_download: :environment do
    require "csv"

    csv_text = Rails.root.join("lib", "data", "piazza_activity_downloads", "2023-01-30_2023-02-06_piazza-we_2023_1_1-stats_summary-2023-03-10").read
    csv = CSV.parse(csv_text, headers: true, encoding: "ISO-8859-1")
    csv.each do |row|
      t = Transaction.new
      t.street_address = row["street"]
      t.city = row["city"]
      t.zip = row["zip"]
      t.state = row["state"]
      t.bedrooms = row["beds"]
      t.square_feet = row["sq_feet"]
      t.category = row["type"]
      t.sold_on = row["sale_date"]
      t.price = row["price"]
      t.lat = row["latitude"]
      t.lng = row["longitude"]
      t.save
      puts "#{t.street_address}, #{t.zip} saved"
    end

    puts "There are now #{Transaction.count} rows in the transactions table"
  end
end
