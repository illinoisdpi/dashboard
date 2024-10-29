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

  def show
  end

  def new
    @placement = Placement.new
  end

  def edit
    @placement = Placement.find(params[:id])
    @enrollments = @cohort.users
  end

  def create
    @placement = Placement.new(placement_params)
    @placement.cohort = @cohort

    if @placement.save
      redirect_to cohort_placements_path(@cohort), notice: "Placement was successfully created."
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @cohort.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @placement.update(placement_params)
      redirect_to cohort_placements_path(@cohort), notice: "Placement was successfully updated."
    else
      @enrollments = @cohort.users # Make sure to load users again for the edit form.
      render :edit
    end
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

  def placement_params
    params.require(:placement).permit(:start_date, :end_date, :cohort_id, :job_description_id, :user_id, :company_id, :salary)
  end
end
