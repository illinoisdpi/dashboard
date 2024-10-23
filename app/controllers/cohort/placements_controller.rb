class Cohort::PlacementsController < ApplicationController
  before_action :set_cohort
  before_action :set_placement, only: %i[show edit update destroy]
  before_action :authorize_cohort

  def index
    @q = policy_scope(Placement).page(params[:page]).ransack(params[:q])
    @placements = @q.result.includes(:user, :job_description, :company).default_order
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Placements", href: cohort_placements_path(@cohort) }
    ]
  end

  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Placements", href: cohort_placements_path(@cohort) },
      { content: "#{@placement.user} - #{@placement.job_description.title}" }
    ]
  end

  # GET /placements/new
  def new
    @placement = Placement.new
  end

  # GET /placements/1/edit
  def edit
  end

  # POST /placements
  def create
    @placement = Placement.new(placement_params)

    if @placement.save
      redirect_to @placement, notice: "Placement was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /placements/1
  def update
    if @placement.update(placement_params)
      redirect_to @placement, notice: "Placement was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /placements/1
  def destroy
    @placement.destroy
    redirect_to placements_url, notice: "Placement was successfully destroyed."
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
    params.require(:placement).permit(:id, :start_date, :end_date, :cohort_id, :job_description_id, :user_id, :company_id, :salary)
  end
end
