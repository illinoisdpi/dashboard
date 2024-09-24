class JobDescriptionsController < ApplicationController
  before_action :set_job_description, only: [:show, :edit, :update, :destroy]

  # GET /job_descriptions
  def index
    @job_descriptions = JobDescription.all
  end

  # GET /job_descriptions/1
  def show
  end

  # GET /job_descriptions/new
  def new
    @job_description = JobDescription.new
  end

  # GET /job_descriptions/1/edit
  def edit
  end

  # POST /job_descriptions
  def create
    @job_description = JobDescription.new(job_description_params)

    if @job_description.save
      redirect_to @job_description, notice: 'Job description was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /job_descriptions/1
  def update
    if @job_description.update(job_description_params)
      redirect_to @job_description, notice: 'Job description was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /job_descriptions/1
  def destroy
    @job_description.destroy
    redirect_to job_descriptions_url, notice: 'Job description was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job_description
    @job_description = JobDescription.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def job_description_params
    params.require(:job_description).permit(:title, :description, :company_id, :role_category)
  end
end
