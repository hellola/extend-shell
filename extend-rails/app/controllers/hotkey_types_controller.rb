class HotkeyTypesController < ApplicationController
  before_action :set_hotkey_type, only: [:show, :edit, :update, :destroy]

  # GET /hotkey_types
  # GET /hotkey_types.json
  def index
    @hotkey_types = HotkeyType.all
  end

  # GET /hotkey_types/1
  # GET /hotkey_types/1.json
  def show
  end

  # GET /hotkey_types/new
  def new
    @hotkey_type = HotkeyType.new
  end

  # GET /hotkey_types/1/edit
  def edit
  end

  # POST /hotkey_types
  # POST /hotkey_types.json
  def create
    @hotkey_type = HotkeyType.new(hotkey_type_params)

    respond_to do |format|
      if @hotkey_type.save
        format.html { redirect_to @hotkey_type, notice: 'Hotkey type was successfully created.' }
        format.json { render :show, status: :created, location: @hotkey_type }
      else
        format.html { render :new }
        format.json { render json: @hotkey_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotkey_types/1
  # PATCH/PUT /hotkey_types/1.json
  def update
    respond_to do |format|
      if @hotkey_type.update(hotkey_type_params)
        format.html { redirect_to @hotkey_type, notice: 'Hotkey type was successfully updated.' }
        format.json { render :show, status: :ok, location: @hotkey_type }
      else
        format.html { render :edit }
        format.json { render json: @hotkey_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotkey_types/1
  # DELETE /hotkey_types/1.json
  def destroy
    @hotkey_type.destroy
    respond_to do |format|
      format.html { redirect_to hotkey_types_url, notice: 'Hotkey type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hotkey_type
      @hotkey_type = HotkeyType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hotkey_type_params
      params.require(:hotkey_type).permit(:name)
    end
end
