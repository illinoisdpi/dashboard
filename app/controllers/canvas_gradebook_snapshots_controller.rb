class CanvasGradebookSnapshotsController < ApplicationController
  before_action :set_cohort
  before_action :set_canvas_gradebook_snapshot, only: %i[show edit update destroy send_biweekly_reports]
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

  def send_biweekly_reports
    if policy(@canvas_gradebook_snapshot).send_biweekly_reports?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      assignment_ids = params[:assignments]

      begin
        discord_service = DiscordService.new(@cohort)

        @cohort.enrollments.student.each do |enrollment|
          next unless enrollment.user.discord_id

          missing_assignments = @canvas_gradebook_snapshot.canvas_submissions
            .where(enrollment: enrollment)
            .where(points: nil)
            .where(canvas_assignment_id: assignment_ids)
            .includes(:canvas_assignment)
            .map(&:canvas_assignment)

          impressions = enrollment.impressions
            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
            .where(staff_only: false)
            .order(created_at: :desc)

          attendances = enrollment.attendances
            .where(occurred_at: start_date.beginning_of_day..end_date.end_of_day)
            .includes(:attendees)
            .order(occurred_at: :desc)

          message = <<~MESSAGE
            **Biweekly Progress Report**
            Period: #{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d")}

            **Missing Assignments:**
            #{missing_assignments.empty? ? "No missing assignments! 🎉" : missing_assignments.map { |a| "- #{a.name}" }.join("\n")}

            **Impressions:**
            #{impressions.empty? ? "No impressions recorded for this period." : impressions.map { |i| "- #{i.emoji} #{i.content}" }.join("\n")}

            **Attendance:**
            #{attendances.empty? ? "No attendance records for this period." : attendances.map { |a| "- #{a.title} (#{a.category.titleize})" }.join("\n")}
          MESSAGE

          # Send the message via Discord
          discord_service.send_dm(
            enrollment.user.discord_id,
            message
          )
        end

        redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot), notice: "Biweekly reports sent successfully!"
      rescue => e
        redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot), alert: "Error sending reports: #{e.message}"
      end
    else
      redirect_to cohort_canvas_gradebook_snapshot_path(@cohort, @canvas_gradebook_snapshot), alert: "You are not authorized to send biweekly reports."
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
