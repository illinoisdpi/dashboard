class RfpIdeaSubmissionsController < ApplicationController
  layout "rfp"
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  before_action { authorize(:rfp_idea_submissions) }
  before_action :set_rfp_idea_submission, only: %i[ show edit update destroy ]
  

  # GET /rfp_idea_submissions/new
  def new
    @rfp_idea_submission = RfpIdeaSubmission.new
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rfp_idea_submission
      @rfp_idea_submission = RfpIdeaSubmission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rfp_idea_submission_params
      params.require(:rfp_idea_submission).permit(:contact_name, :contact_email, :title, :details, :contact_phone)
    end
end
