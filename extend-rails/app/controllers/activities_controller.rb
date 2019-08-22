class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.for_today
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  def daily

  end

  # POST /activities
  # POST /activities.json
  def create
    name = activity_params['name']
    activity_p = activity_params.except('name')
    @activity = Activity.new(activity_p)
    if name.present?
      @activity.activity_group = ActivityGroup.determine_for_activity(name: name, activity: @activity)
    end
    if @activity.time_activated.nil?
      @activity.time_activated = DateTime.now
    end
    latest = Activity.latest_for_host(@activity.host)
    save_required = latest.nil? || !latest.same_as?(@activity)

    respond_to do |format|
      if save_required && @activity.save
        latest.time_deactivated = @activity.time_activated
        latest.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:host, :application, :title, :time_activated, :name)
    end
end
