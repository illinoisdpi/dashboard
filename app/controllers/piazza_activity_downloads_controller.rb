class PiazzaActivityDownloadsController < ApplicationController
  before_action :set_cohort
  before_action :set_piazza_activity_download, only: %i[show edit update destroy]

  # GET /piazza_activity_downloads or /piazza_activity_downloads.json
  def index
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_downloads_path(@cohort)}
    ]

    @piazza_activity_downloads = @cohort.piazza_activity_downloads.default_order
  end

  # GET /piazza_activity_downloads/1 or /piazza_activity_downloads/1.json
  def show
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_downloads_path(@cohort)},
      {content: @piazza_activity_download.to_s}
    ]
    # ransack the activity breakdowns:  
    @q = @piazza_activity_download.piazza_activity_breakdowns.ransack(params[:q])
    @piazza_activity_breakdowns = @q.result()
  end

  # GET /piazza_activity_downloads/new
  def new
    @breadcrumbs = [
      {content: "Cohorts", href: cohorts_path},
      {content: @cohort.to_s, href: cohort_path(@cohort)},
      {content: "Piazza activity reports", href: cohort_piazza_activity_downloads_path(@cohort)},
      {content: "New"}
    ]

    @piazza_activity_download = @cohort.piazza_activity_downloads.build
  end

  # GET /piazza_activity_downloads/1/edit
  def edit
  end

  # POST /piazza_activity_downloads or /piazza_activity_downloads.json
  def create
    @piazza_activity_download = PiazzaActivityDownload.new(piazza_activity_download_params)

    respond_to do |format|
      if @piazza_activity_download.save
        format.html { redirect_to cohort_piazza_activity_download_url(@piazza_activity_download.cohort, @piazza_activity_download), notice: "Piazza activity report was successfully created." }
        format.json { render :show, status: :created, location: @piazza_activity_download }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_download.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /piazza_activity_downloads/1 or /piazza_activity_downloads/1.json
  def update
    respond_to do |format|
      if @piazza_activity_download.update(piazza_activity_download_params)
        format.html { redirect_to cohort_piazza_activity_download_url(@piazza_activity_download.cohort, @piazza_activity_download), notice: "Piazza activity report was successfully updated." }
        format.json { render :show, status: :ok, location: @piazza_activity_download }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @piazza_activity_download.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /piazza_activity_downloads/1 or /piazza_activity_downloads/1.json
  def destroy
    @piazza_activity_download.destroy

    respond_to do |format|
      format.html { redirect_to piazza_activity_downloads_url, notice: "Piazza activity report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_piazza_activity_download
    @piazza_activity_download = PiazzaActivityDownload.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def piazza_activity_download_params
    params.require(:piazza_activity_download).permit(:activity_from, :activity_until, :cohort_id, :csv_file)
  end
end
