namespace :dev do
  desc "Hydrate the database with sample data"
  task prime: :environment do
    usernames = %w[alice bob carol]

    usernames.each do |username|
      User.create(
        email: "#{username}@example.com",
        password: "password"
      )
    end
  end
end
