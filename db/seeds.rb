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
  homar4@uillinois.edu
]

user_info = emails.map { |email| {email: email, password: "password"} }

Rails.logger.debug User.create(user_info)

Rails.logger.debug Cohort.create(
  [
    {
      year: 2022,
      generation: 1,
      number: 1,
      name: "The Pioneers",
      canvas_shortname: "WE-2022-1.1-SDF"
    },
    {
      year: 2023,
      generation: 1,
      number: 1,
      name: "Hash Rockets",
      canvas_shortname: "WE-2023-1.1-SDF"
    },
    {
      year: 2023,
      generation: 2,
      number: 1,
      name: "Fullstack Pancakes",
      canvas_shortname: "WE-2023-2.1-SDF"
    }
  ]
)
