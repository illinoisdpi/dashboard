class Cohort::ImpressionsController < ApplicationController
  include Csvable
  before_action :set_cohort
  before_action :set_impression, only: %i[ show edit update destroy ]
  before_action { authorize(@impression || Impression) }

  # GET /impressions or /impressions.json
  def index
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Impressions", href: cohort_impressions_path(@cohort)}
    ]
    @impressions = policy_scope(@cohort.impressions.default_order)

    respond_to do |format|
      format.html
      format.csv { export_to_csv(@impressions) }
    end
  end

  # GET /impressions/1 or /impressions/1.json
  def show
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Impressions", href: cohort_impressions_path(@cohort)},
      {content: @impression}
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
        format.html { redirect_to cohort_impression_url(@cohort, @impression), notice: "Impression was successfully created." }
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
        format.html { redirect_to cohort_impression_url(@cohort, @impression), notice: "Impression was successfully updated." }
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

  def set_cohort
    @cohort = Cohort.find(params.fetch(:cohort_id)) if params.dig(:cohort_id).present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_impression
    @impression = policy_scope(Impression).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def impression_params
    params.require(:impression).permit(:author_id, :subject_id, :content, :emoji)
  end

  # def generate_csv(impressions)
  #   CSV.generate(headers: true) do |csv|
  #     csv << ["ID", "Created At", "Content", "Emoji", "Updated At", "Author ID", "Author Email", "Author First Name", "Author Last Name", "Subject ID", "Subject Email", "Subject First Name", "Subject Last Name"]
      
  #     impressions.each do |impression|
  #       csv << [
  #         impression.id,
  #         impression.created_at,
  #         impression.updated_at,
  #         impression.content,
  #         impression.emoji,
  #         impression.author_id,
  #         impression.author.email,
  #         impression.author.first_name,
  #         impression.author.last_name,
  #         impression.subject_id,
  #         impression.subject.email,
  #         impression.subject.first_name,
  #         impression.subject.last_name
  #       ]
  #     end
  #   end
  # end
end
