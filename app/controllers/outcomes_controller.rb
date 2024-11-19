class OutcomesController < ApplicationController
  layout "outcomes"
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  before_action { authorize(:placement) }

  def index
    @q = policy_scope(Placement).page(params[:page]).ransack(params[:q])
    @placements = @q.result.includes(:user, :job_description, :company).default_order.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /placements/1
  def show
    @breadcrumbs = [
      { content: "Dashboard", href: dashboard_root_path },
      { content: "#{@placement.user} - #{@placement.company.name} ", href: placement_path(@placement) }
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
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @placement.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /placements/1
  def update
    if @placement.update(placement_params)
      redirect_to @placement, notice: "Placement was successfully updated."
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @placement.errors, status: :unprocessable_entity }
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
