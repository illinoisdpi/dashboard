# == Schema Information
#
# Table name: cohorts
#
#  id                   :uuid             not null, primary key
#  canvas_shortname     :string
#  month                :integer          not null
#  name                 :string
#  number               :integer          not null
#  piazza_course_number :string
#  started_on           :date
#  year                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :cohort do
    canvas_shortname { "WE-2022-1.2-SDF" }
    year { 2022 }
    month { 1 }
    number { 2 }
    started_on { Date.today }
  end
end
