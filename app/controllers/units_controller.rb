class UnitsController < ApplicationController
  helper StatesHelper
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create]
  layout 'sessions', only: [:new, :create]

  # GET /units/1
  # GET /units/1.json
  def show
    cookies[:unit_id] = @unit.id
  end

  # GET /units/new
  def new
    @unit = Unit.new
    @unit.scouts.build
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    puts unit_params[:scouts_attributes]
    puts "*"
    if @unit.save
      @scout = @unit.scouts.new(first_name: scout_params[:first_name], last_name: scout_params[:last_name], unit_id: @unit.id, email: scout_params[:email], password:  scout_params[:password], password_confirmation: scout_params[:password_confirmation], is_super_admin: true)
      if @scout.save
        redirect_to root_path, notice: 'Unit was successfully created.'
      else
        render :new, notice: @scout.errors.full_messages
      end
    else
      render :new, notice: @unit.errors.full_messages
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:name, :street_address_1, :street_address_2, :city, :zip_code, :state_postal_code, :treasurer_first_name, :treasurer_last_name, :treasurer_email, :first_name, :last_name, :email)
    end

    def scout_params
      params.require(:scout).permit( :password, :password_confirmation, :first_name, :last_name, :email )
    end
end

