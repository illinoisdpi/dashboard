class RfpIdeaSubmissionsController < ApplicationController
  layout "rfp"
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  before_action { authorize(:rfp_idea_submissions) }
  before_action :set_rfp_idea_submission, only: %i[ show edit update destroy ]
  
  # GET /rfp_idea_submissions or /rfp_idea_submissions.json
  def index
    @rfp_idea_submissions = RfpIdeaSubmission.all
  end

  # GET /rfp_idea_submissions/1 or /rfp_idea_submissions/1.json
  def show
  end

  # GET /rfp_idea_submissions/new
  def new
    @rfp_idea_submission = RfpIdeaSubmission.new
  end

  # GET /rfp_idea_submissions/1/edit
  def edit
  end

  # POST /rfp_idea_submissions or /rfp_idea_submissions.json
  def create
    @rfp_idea_submission = RfpIdeaSubmission.new(rfp_idea_submission_params)

    respond_to do |format|
      if @rfp_idea_submission.save
        format.html { redirect_to new_rfp_idea_submission_path, notice: "Your project idea was submitted successfully." }
        format.json { render :show, status: :created, location: @rfp_idea_submission }
      else
        flash[:alert] = 'Error submitting project. Please try again.'
        format.html { redirect_to new_rfp_idea_submission_path }
        format.json { render json: @rfp_idea_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rfp_idea_submissions/1 or /rfp_idea_submissions/1.json
  def update
    respond_to do |format|
      if @rfp_idea_submission.update(rfp_idea_submission_params)
        format.html { redirect_to rfp_idea_submission_url(@rfp_idea_submission), notice: "Rfp idea submission was successfully updated." }
        format.json { render :show, status: :ok, location: @rfp_idea_submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rfp_idea_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rfp_idea_submissions/1 or /rfp_idea_submissions/1.json
  def destroy
    @rfp_idea_submission.destroy

    respond_to do |format|
      format.html { redirect_to rfp_idea_submissions_url, notice: "Rfp idea submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rfp_idea_submission
      @rfp_idea_submission = RfpIdeaSubmission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rfp_idea_submission_params
      params.require(:rfp_idea_submission).permit(:contact_name, :email, :title, :details, :phone_number)
    end
end
