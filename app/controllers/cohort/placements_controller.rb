class Cohort::PlacementsController < ApplicationController
  before_action :set_cohort
  before_action :authorize_cohort

  def index
    @placements = @cohort.users.placements_for_cohort(:id)
  end

  def show
    @cohort = policy_scope(Cohort).find(params[:id])
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort
    authorize policy_scope(Cohort).find(@cohort.id)
  end
end
