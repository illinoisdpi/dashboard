class PlacementsController < ApplicationController
  layout "outcomes"
  skip_before_action :authenticate_user!
  before_action { authorize(:placement) }

def index
  @q = policy_scope(Placement).page(params[:page]).ransack(params[:q])
  @placements = @q.result.includes(:user, :job_description, :company).default_order
end


  # GET /placements/1
  def show
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

  # Use callbacks to share common setup or constraints between actions.
  def set_placement
    @placement = Placement.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def placement_params
    params.require(:placement).permit(:start_date, :end_date, :cohort_id, :job_description_id, :user_id, :company_id, :salary)
  end
end
