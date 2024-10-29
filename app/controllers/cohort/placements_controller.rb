class Cohort::PlacementsController < ApplicationController
  before_action :set_cohort
  before_action :set_placement, only: %i[show edit update destroy]
  before_action { authorize(@cohort || Cohort) }

  def index
    @q = policy_scope(@cohort.placements).page(params[:page]).ransack(params[:q])
    @placements = @q.result.includes(:user, :job_description, :company).default_order.page(params[:page]).per(5)
    @placement = Placement.find(params[:placement_id]) if params[:placement_id]

    respond_to do |format|
      format.html
      format.turbo_stream
    end

    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Placements", href: cohort_placements_path(@cohort) }
    ]
  end

  def show
  end

  def new
    @placement = Placement.new
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Placements", href: cohort_placements_path(@cohort) },
      { content: "New" }
    ]
  end

  def edit
    @placement = Placement.find(params[:id])
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Placements", href: cohort_placements_path(@cohort) },
      { content: "Edit" }
    ]
  end

  def create
    @placement = @cohort.placements.new(placement_params)
    @placement.cohort = @cohort

    if @placement.save
      redirect_to cohort_placements_path(@cohort), notice: "Placement was successfully created."
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @placement.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @placement.update(placement_params)
      redirect_to cohort_placements_path(@cohort), notice: "Placement was successfully updated."
    else
      @users = @cohort.users
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @placement.errors, status: :unprocessable_entity }
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
    authorize @cohort || Cohort
  end

  def placement_params
    params.require(:placement).permit(:start_date, :end_date, :cohort_id, :job_description_id, :user_id, :company_id, :salary)
  end
end
