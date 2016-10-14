class ScoutsController < ApplicationController
  before_action :set_scout, only: [:show, :edit, :update, :destroy]

  # GET /scouts
  # GET /scouts.json
  def index
    if current_scout.is_admin?
      if params[:inactive]
        @scouts = @unit.scouts.inactive
      elsif params[:administrators]
        @admins = @unit.scouts.admin
      else
        @scouts = @unit.scouts.active.not_admin.order(:first_name)
      end
    end
  end

  # GET /scouts/1
  # GET /scouts/1.json
  def show
    @events = @scout.events
  end

  # GET /scouts/new
  def new
    @scout = Scout.new
  end

  # GET /scouts/1/edit
  def edit
  end

  # POST /scouts
  # POST /scouts.json
  def create
    @scout = Scout.build(scout_params)
    @scout.unit_id = 1

    respond_to do |format|
      if @scout.save
        format.html { redirect_to @scout, notice: 'Scout was successfully created.' }
        format.json { render :show, status: :created, location: @scout }
      else
        format.html { render :new }
        format.json { render json: @scout.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_password
    @scout = @unit.scouts.find(params[:scout_id])
  end

  # PATCH/PUT /scouts/1
  # PATCH/PUT /scouts/1.json
  def update
    respond_to do |format|
      if @scout.update(scout_params)
        format.html { redirect_to @scout, notice: 'Scout was successfully updated.' }
        format.json { render :show, status: :ok, location: @scout }
      else
        format.html { render :edit }
        format.json { render json: @scout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scouts/1
  # DELETE /scouts/1.json
  def destroy
    @scout.update(is_active: false)
    redirect_to scouts_path, notice: 'Scout was successfully moved to "inactive".'
  end

  private
    def set_scout
      if @unit
        @scout = @unit.scouts.find(params[:id])
      else
        @scout = Scout.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scout_params
      params.require(:scout).permit(:first_name, :last_name, :email, :parent_first_name, :parent_last_name, :password, :password_confirmation, :default_event_id, :is_active, :is_site_sales_admin, :is_take_orders_admin, :is_online_sales_admin, :is_admin, :is_super_admin, :is_prizes_admin)
    end
end
