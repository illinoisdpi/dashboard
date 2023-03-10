class PiazzaActivityBreakdownsController < ApplicationController
  before_action :set_piazza_activity_breakdown, only: %i[ show edit update destroy ]

  # GET /piazza_activity_breakdowns or /piazza_activity_breakdowns.json
  def index
    @piazza_activity_breakdowns = PiazzaActivityBreakdown.all
  end

  # GET /piazza_activity_breakdowns/1 or /piazza_activity_breakdowns/1.json
  def show
  end

  # GET /piazza_activity_breakdowns/new
  def new
    @piazza_activity_breakdown = PiazzaActivityBreakdown.new
  end

  # GET /piazza_activity_breakdowns/1/edit
  def edit
  end

  # POST /piazza_activity_breakdowns or /piazza_activity_breakdowns.json
  def create
    @piazza_activity_breakdown = PiazzaActivityBreakdown.new(piazza_activity_breakdown_params)

    respond_to do |format|
      if @piazza_activity_breakdown.save
        format.html { redirect_to piazza_activity_breakdown_url(@piazza_activity_breakdown), notice: "Piazza activity breakdown was successfully created." }
        format.json { render :show, status: :created, location: @piazza_activity_breakdown }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /piazza_activity_breakdowns/1 or /piazza_activity_breakdowns/1.json
  def update
    respond_to do |format|
      if @piazza_activity_breakdown.update(piazza_activity_breakdown_params)
        format.html { redirect_to piazza_activity_breakdown_url(@piazza_activity_breakdown), notice: "Piazza activity breakdown was successfully updated." }
        format.json { render :show, status: :ok, location: @piazza_activity_breakdown }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /piazza_activity_breakdowns/1 or /piazza_activity_breakdowns/1.json
  def destroy
    @piazza_activity_breakdown.destroy

    respond_to do |format|
      format.html { redirect_to piazza_activity_breakdowns_url, notice: "Piazza activity breakdown was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_piazza_activity_breakdown
      @piazza_activity_breakdown = PiazzaActivityBreakdown.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def piazza_activity_breakdown_params
      params.require(:piazza_activity_breakdown).permit(:enrollment_id, :emails, :role, :groups, :days_online, :posts, :edits_to_posts, :answers, :edits_to_answers, :followups, :replies_to_followups, :instructor_good_question, :instructor_good_answer, :instructor_good_comment, :student_good_question, :student_thanks_on_answer, :student_helpful_on_followups, :good_question_given, :thanks_on_answers_given, :helpful_on_followups_given, :post_views, :live_qa_upvotes, :piazza_activity_download_id)
    end
end
