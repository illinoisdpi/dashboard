class ImpressionsController < ApplicationController
  before_action :set_impression, only: %i[ show edit update destroy ]
  before_action { authorize(@impression || Impression) }

  # GET /impressions/1 or /impressions/1.json
  def show
    @breadcrumbs = [
      {content: "Dashboard", href: dashboard_root_path},
      {content: @impression.to_s, href: impression_path(@impression)},
    ]
  end

  # GET /impressions/new
  def new
    @impression = current_user.authored_impressions.new
  end

  # GET /impressions/1/edit
  def edit
  end

  # POST /impressions or /impressions.json
  def create
    @impression = current_user.authored_impressions.new(impression_params)

    respond_to do |format|
      if @impression.save
        format.html { redirect_to impression_url(@impression), notice: "Impression was successfully created." }
        format.json { render :show, status: :created, location: @impression }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @impression.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /impressions/1 or /impressions/1.json
  def update
    respond_to do |format|
      if @impression.update(impression_params)
        format.html { redirect_to impression_url(@impression), notice: "Impression was successfully updated." }
        format.json { render :show, status: :ok, location: @impression }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @impression.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impressions/1 or /impressions/1.json
  def destroy
    @impression.destroy

    respond_to do |format|
      format.html { redirect_to impressions_url, notice: "Impression was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_impression
    @impression = Impression.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def impression_params
    params.require(:impression).permit(:author_id, :subject_id, :content, :emoji)
  end
end
