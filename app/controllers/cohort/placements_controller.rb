class Cohort::PlacementsController < ApplicationController
  before_action :set_cohort
  before_action :set_placement, only: %i[show edit update destroy]
  before_action :authorize_cohort

  def index
    @q = policy_scope(@cohort.placements).page(params[:page]).ransack(params[:q])
    @placements = @q.result.includes(:user, :job_description, :company).default_order.page(params[:page]).per(5)
    @placement = Placement.find(params[:placement_id]) if params[:placement_id]

    respond_to do |format|
      format.html # Renders index.html.erb
      format.turbo_stream do
        render turbo_stream: [
                 turbo_stream.replace("placement_list", partial: "cohort/placements/placement_list", locals: { placements: @placements }),
                 turbo_stream.replace("placement", partial: "cohort/placements/placement", locals: { placement: @placement })
               ]
      end
    end
  end

  def new
    @placement = Placement.new
  end

  private

  def set_placement
    @placement = Placement.find(params[:id])
  end

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def authorize_cohort
    authorize policy_scope(Cohort).find(@cohort.id)
  end
end
