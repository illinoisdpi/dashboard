# == Schema Information
#
# Table name: cohorts
#
#  id                   :uuid             not null, primary key
#  canvas_shortname     :string
#  generation           :integer          not null
#  name                 :string
#  number               :integer          not null
#  piazza_course_number :string
#  year                 :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe Cohort do
  pending "add some examples to (or delete) #{__FILE__}"
end
