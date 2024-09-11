class Cohort::CommentsController < ApplicationController
  before_action :set_impression
  before_action :set_cohort

  # POST /cohorts/:cohort_id/impressions/:impression_id/comments
  def create
    @impression = Impression.find(params[:impression_id])
    @comment = @impression.comments.new(comment_params)
    @comment.user = current_user
    @comment.impression = @impression
    authorize @comment

    if @comment.save
      redirect_to cohort_impression_path(@cohort, @impression), notice: "Comment was successfully added."
    else
      redirect_to cohort_impression_path(@cohort, @impression), alert: "Failed to add comment."
    end
  end

  # DELETE /cohorts/:cohort_id/impressions/:impression_id/comments/:id
  def destroy
    @comment = @impression.comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to cohort_impression_path(@cohort, @impression), notice: "Comment was successfully deleted."
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id]) if params[:cohort_id].present?
  end

  def set_impression
    @impression = Impression.find(params[:impression_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id, :impression_id)
  end
end
