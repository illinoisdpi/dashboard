# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

emails = %w[
  aparan3@uic.edu
  diamondm@uillinois.edu
  ian@biggreen.company
  jfoil@uillinois.edu
  raghu@firstdraft.com
  schaud47@uic.edu
  sfarzo@uillinois.edu
  sjaime@uillinois.edu
  tula@uillinois.edu
]

user_info = emails.map { |email| {email: email, password: "password"} }

Rails.logger.debug User.create(user_info)

Rails.logger.debug Cohort.create(
  [
    {
      year: 2022,
      generation: 1,
      number: 1,
      name: "The Pioneers"
    },
    {
      year: 2023,
      generation: 1,
      number: 1,
      name: "Hash Rockets"
    },
    {
      year: 2023,
      generation: 2,
      number: 1,
      name: "Fullstack Pancakes"
    }
  ]
)
