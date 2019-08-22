class ActivityGroupsController < ApplicationController
  before_action :set_activity_group, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /activity_groups
  # GET /activity_groups.json
  def index
    should_title_search = params[:title].present?
    @activity_groups =
      if should_title_search
        ActivityGroup.title_search(params[:title])
      else
        ActivityGroup.all
      end
  end

  # GET /activity_groups/1
  # GET /activity_groups/1.json
  def show
  end

  # GET /activity_groups/new
  def new
    @activity_group = ActivityGroup.new
  end

  # GET /activity_groups/1/edit
  def edit

  end

  # POST /activity_groups
  # POST /activity_groups.json
  def create
    @activity_group = ActivityGroup.new(activity_group_params)

    respond_to do |format|
      if @activity_group.save
        format.html { redirect_to @activity_group, notice: 'Activity group was successfully created.' }
        format.json { render :show, status: :created, location: @activity_group }
      else
        format.html { render :new }
        format.json { render json: @activity_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_groups/1
  # PATCH/PUT /activity_groups/1.json
  def update
    merged = false
    if params[:merge_id].present? && params[:merge_id] != @activity_group.id
      merged_group = ActivityGroup.find(params[:merge_id])
      merged_group.merge_from(@activity_group)
      merged = true
    end
    respond_to do |format|
      if merged
        format.html { redirect_to merged_group, notice: 'Activity group was successfully merged'}
        format.json { render json: 'successfully merged' }
      elsif @activity_group.update(activity_group_params)
        format.html { redirect_to @activity_group, notice: 'Activity group was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_group }
      else
        format.html { render :edit }
        format.json { render json: @activity_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_groups/1
  # DELETE /activity_groups/1.json
  def destroy
    @activity_group.destroy
    respond_to do |format|
      format.html { redirect_to activity_groups_url, notice: 'Activity group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_group
      @activity_group = ActivityGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_group_params
      params.require(:activity_group).permit(:name, :activity, :merge_id)
    end
end
