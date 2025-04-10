class RecurringMessagesController < ApplicationController
  before_action :set_cohort
  before_action :set_channel
  before_action :set_recurring_message, only: %i[edit update destroy]
  before_action :authorize_cohort_discord

  def edit
    @breadcrumbs = [
      { content: "Cohorts", href: cohorts_path },
      { content: @cohort.to_s, href: cohort_path(@cohort) },
      { content: "Discord Channels", href: cohort_discord_channels_path(@cohort) },
      { content: "Edit" }
    ]
  end

  def create
    @recurring_message = @cohort.recurring_messages.new(recurring_message_params)
    @recurring_message.channel_id = @channel[:id]

    if @recurring_message.save
      @recurring_message.schedule_discord_message
      flash[:notice] = "Recurring message scheduled successfully."
      redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
    else
      flash.now[:alert] = "Error scheduling recurring message."
      render :new
    end
  end

  def update
    if @recurring_message.update(recurring_message_params)
      @recurring_message.schedule_discord_message
      flash[:notice] = "Recurring message updated successfully."
      redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
    else
      flash.now[:alert] = "Error updating recurring message."
      render :edit
    end
  end

  def destroy
    @recurring_message.destroy
    flash[:notice] = "Recurring message deleted."
    redirect_to cohort_discord_channel_path(@cohort, @channel[:id])
  end

  private

  def set_cohort
    @cohort = Cohort.find(params[:cohort_id])
  end

  def set_channel
    @channel = DiscordService.new.fetch_channel(@cohort.discord_server_id, params[:discord_channel_id])
  end

  def set_recurring_message
    @recurring_message = @cohort.recurring_messages.find(params[:id])
  end

  def authorize_cohort_discord
    authorize @cohort, :discord?
  end

  def recurring_message_params
    params.require(:recurring_message).permit(:message_content, :scheduled_time, :frequency, days_of_week: [])
  end
end
