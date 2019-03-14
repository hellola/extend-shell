class HotkeysController < ApplicationController
  before_action :set_hotkey, only: [:show, :edit, :update, :destroy]

  # GET /hotkeys
  # GET /hotkeys.json
  def index
    @hotkeys = Hotkey.all
  end

  # GET /hotkeys/1
  # GET /hotkeys/1.json
  def show
  end

  # GET /hotkeys/new
  def new
    @hotkey = Hotkey.new
  end

  # GET /hotkeys/1/edit
  def edit
  end

  def exec_by_name
    name = params[:name]
    @hotkey = Hotkey.where('name = ? OR full_name = ?',name, name).first if name.present?
    success = !@hotkey.nil?
    @hotkey&.execute
    respond_to do |format|
      format.json { render json: { success: success } }
      format.html { render :index }
    end
  end

  def exec
    id = params[:id]
    @hotkey = Hotkey.find(id) if id.present?
    @hotkey.execute
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  # POST /hotkeys
  # POST /hotkeys.json
  def create
    @hotkey = Hotkey.new(hotkey_params)

    respond_to do |format|
      if @hotkey.save
        format.html { redirect_to @hotkey, notice: 'Hotkey was successfully created.' }
        format.json { render :show, status: :created, location: @hotkey }
      else
        format.html { render :new }
        format.json { render json: @hotkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotkeys/1
  # PATCH/PUT /hotkeys/1.json
  def update
    respond_to do |format|
      if @hotkey.update(hotkey_params)
        format.html { redirect_to @hotkey, notice: 'Hotkey was successfully updated.' }
        format.json { render :show, status: :ok, location: @hotkey }
      else
        format.html { render :edit }
        format.json { render json: @hotkey.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotkeys/1
  # DELETE /hotkeys/1.json
  def destroy
    @hotkey.destroy
    respond_to do |format|
      format.html { redirect_to hotkeys_url, notice: 'Hotkey was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotkey
      @hotkey = Hotkey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotkey_params
      params.require(:hotkey).permit(:key, :command, :location_id, :executes, :name, :hotkey_type_id, :parent_id, :operating_system_id)
    end
end
