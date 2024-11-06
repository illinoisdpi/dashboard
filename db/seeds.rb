# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = [
  {
    email: "ian@biggreen.company",
    first_name: "Ian",
    last_name: "Heraty"
  },
  {
    email: "diamondm@uillinois.edu",
    first_name: "Morgan",
    last_name: "Diamond"
  },
  {
    email: "raghu@firstdraft.com",
    first_name: "Raghu",
    last_name: "Betina"
  },
  {
    email: "sjaime@uillinois.edu",
    first_name: "Sanjuana",
    last_name: "Jaime-Nix"
  },
  {
    email: "tula@uillinois.edu",
    first_name: "Tula",
    last_name: "Kuechenmeister"
  },
  {
    email: "homar4@uillinois.edu",
    first_name: "Haneen",
    last_name: "Omar"
  },
  {
    email: "jfoil@uillinois.edu",
    first_name: "Jennifer",
    last_name: "Foil"
  },
  {
    email: "aparan3@uic.edu",
    first_name: "Anantha",
    last_name: "Parankusham"
  }
]

users.each do |user_info|
  user = User.create(user_info.merge(password: "password"))
  user.add_role(:admin)
end

Rails.logger.debug Cohort.create(
  [
    {
      year: 2022,
      generation: 1,
      number: 1,
      name: "The Pioneers",
      canvas_shortname: "WE-2022-1.1-SDF",
      started_on: "September 19th, 2022"
    },
    {
      year: 2023,
      generation: 1,
      number: 1,
      name: "Hash Rockets",
      canvas_shortname: "WE-2023-1.1-SDF",
      started_on: "January 30th, 2023"
    },
    {
      year: 2023,
      generation: 2,
      number: 1,
      name: "Fullstack Pancakes",
      canvas_shortname: "WE-2023-2.1-SDF",
      started_on: "February 27th, 2023"
    }
  ]
)
