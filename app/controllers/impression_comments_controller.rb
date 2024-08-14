class ImpressionCommentsController < ApplicationController
  before_action :set_impression
  before_action :set_cohort

  # POST /impressions/:impression_id/impression_comments
  def create
    @comment = @impression.impression_comments.new(impression_comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      redirect_to "/cohort/:cohort_id/impressions/:id", notice: "Comment was successfully added."
    else
      redirect_to "/cohort/:cohort_id/impressions/:id", alert: "Failed to add comment."
    end
  end

  # DELETE /impressions/:impression_id/impression_comments/:id
  def destroy
    @comment = @impression.impression_comments.find(params[:id])
    authorize @comment
    @comment.destroy
    redirect_to "/cohort/:cohort_id/impressions/:id", notice: "Comment was successfully deleted."
  end

  private

  def set_cohort
    @cohort = Cohort.find(params.fetch(:cohort_id)) if params.dig(:cohort_id).present?
  end

  def set_impression
    @impression = Impression.find(params[:impression_id])
  end

  def impression_comment_params
    params.require(:impression_comment).permit(:content)
  end
end
