# == Schema Information
#
# Table name: cohorts
#
#  id                   :uuid             not null, primary key
#  generation           :integer          not null
#  name                 :string
#  number               :integer          not null
#  piazza_course_number :string
#  year                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Cohort < ApplicationRecord
end
