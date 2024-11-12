class CanvasGradebookSnapshotsController < ApplicationController
  before_action :set_cohort
  before_action :set_canvas_gradebook_snapshot, only: %i[show edit update destroy]
  before_action { authorize(@canvas_gradebook_snapshot || CanvasGradebookSnapshot) }

  # GET /canvas_gradebook_snapshots or /canvas_gradebook_snapshots.json
  def index
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Canvas gradebook snapshots", href: cohort_canvas_gradebook_snapshots_path(@cohort) }
    ]

    @canvas_gradebook_snapshots = policy_scope(@cohort.canvas_gradebook_snapshots.default_order)
  end

  # GET /canvas_gradebook_snapshots/1 or /canvas_gradebook_snapshots/1.json
  def show
    respond_to do |format|
      format.html
      format.csv { send_data(@canvas_gradebook_snapshot.to_csv, filename: @canvas_gradebook_snapshot.csv_filename, type: "text/csv") }
    end
  end

  # GET /canvas_gradebook_snapshots/new
  def new
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Canvas gradebook snapshots", href: cohort_canvas_gradebook_snapshots_path(@cohort) },
      { content: "New" }
    ]

    @canvas_gradebook_snapshot = @cohort.canvas_gradebook_snapshots.build
  end

  # GET /canvas_gradebook_snapshots/1/edit
  def edit
  end

  # POST /canvas_gradebook_snapshots or /canvas_gradebook_snapshots.json
  def create
    @canvas_gradebook_snapshot = CanvasGradebookSnapshot.new(canvas_gradebook_snapshot_params.merge(user: current_user))

    respond_to do |format|
      if @canvas_gradebook_snapshot.save
        format.html { redirect_to cohort_canvas_gradebook_snapshot_url(@canvas_gradebook_snapshot.cohort, @canvas_gradebook_snapshot), notice: "Canvas gradebook snapshot was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canvas_gradebook_snapshots/1 or /canvas_gradebook_snapshots/1.json
  def destroy
    @canvas_gradebook_snapshot.destroy

    respond_to do |format|
      format.html { redirect_to cohort_canvas_gradebook_snapshots_url(@cohort), notice: "Canvas gradebook snapshot was successfully destroyed." }
    end
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_canvas_gradebook_snapshot
    @canvas_gradebook_snapshot = CanvasGradebookSnapshot.find(params[:id])
  end

  def canvas_gradebook_snapshot_params
    params.require(:canvas_gradebook_snapshot).permit(:cohort_id, :csv_file)
  end
end
