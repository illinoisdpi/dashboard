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
#  discord_server_id    :string
#
require "rails_helper"

RSpec.describe Cohort do
  pending "add some examples to (or delete) #{__FILE__}"
end
