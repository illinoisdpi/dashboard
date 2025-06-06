class Cohort::ImpressionsController < ApplicationController
  before_action :set_cohort
  before_action :set_impression, only: %i[show edit update destroy]
  before_action { authorize(@impression || Impression) }

  # GET /impressions or /impressions.json
  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Impressions", href: cohort_impressions_path(@cohort) }
    ]

    @q = policy_scope(@cohort.impressions.includes(subject: :user)).ransack(params[:q])
    @impressions = @q.result.default_order

    respond_to do |format|
      format.html { @impressions = @impressions.page(params[:page]).per(params.fetch(:per_page, 10))}
      format.csv { send_data(Impression.to_csv(@impressions), filename: csv_filename, type: "text/csv") }
    end
  end

  # GET /impressions/1 or /impressions/1.json
  def show
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Impressions", href: cohort_impressions_path(@cohort) },
      { content: @impression }
    ]
  end

  # GET /impressions/new
  def new
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Impressions", href: cohort_impressions_path(@cohort) },
      { content: "New" }
    ]
    @impression = current_user.authored_impressions.new
  end

  # GET /impressions/1/edit
  def edit
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Impressions", href: cohort_impressions_path(@cohort) },
      { content: "Edit" }
    ]
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

  def search
    @subjects = @cohort.enrollments.filter_by_name(params[:subject_search])

    respond_to do |format|
      format.turbo_stream
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
    params.require(:impression).permit(:author_id, :subject_id, :content, :emoji, :staff_only)
  end

  def csv_filename
    return "#{Time.zone.today}-impressions.csv" if params[:q].blank?

    formatted_query_params = params[:q].values.compact_blank.join("-")

    "#{Time.zone.today}-impressions-#{formatted_query_params}.csv"
  end
end
