class RfpIdeaSubmissionsController < ApplicationController
  layout "rfp"
  skip_before_action :authenticate_user!
  skip_after_action :verify_policy_scoped
  before_action { authorize(:rfp_idea_submissions) }

  # GET /rfp_idea_submissions/new
  def new
    @rfp_idea_submission = RfpIdeaSubmission.new
  end

  # POST /rfp_idea_submissions or /rfp_idea_submissions.json
  def create
    @rfp_idea_submission = RfpIdeaSubmission.new(rfp_idea_submission_params)

    respond_to do |format|
      if @rfp_idea_submission.save
        # Send confirmation email to the submitter
        RfpIdeaSubmissionsMailer.confirmation(@rfp_idea_submission).deliver_now

        format.html { redirect_to new_rfp_idea_submission_path, notice: "Your project idea was submitted successfully." }
        format.json { render :show, status: :created, location: @rfp_idea_submission }
      else
        flash[:alert] = "Error submitting idea. Please complete all required fields and try again."
        format.html { redirect_to new_rfp_idea_submission_path }
        format.json { render json: @rfp_idea_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def rfp_idea_submission_params
    params.require(:rfp_idea_submission).permit(:contact_name, :contact_email, :title, :details, :contact_phone)
  end
end
