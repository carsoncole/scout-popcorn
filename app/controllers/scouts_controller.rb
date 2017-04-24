class ScoutsController < ApplicationController
  before_action :set_scout, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create, :forgot_password]
  layout 'sessions', only: [:new, :create, :forgot_password]

  # GET /scouts
  # GET /scouts.json
  def index
    if current_scout.admin?
      @inactive_scouts = @scouts = @unit.scouts.inactive
      @scouts = @unit.scouts.active.not_admin.order(:first_name)
      @administrators = @unit.scouts.active.admin
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
    @units = Unit.active.order(:name)
  end

  # GET /scouts/1/edit
  def edit
  end

  # POST /scouts
  # POST /scouts.json
  def create
    @scout = Scout.new(scout_params)

    if @scout.save
      redirect_to root_path, notice: 'Your account was successfully created. Please login to continue'
    else
      @units = Unit.active.order(:name)
      render :new
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

  def forgot_password
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
      params.require(:scout).permit(:first_name, :last_name, :email, :parent_first_name, :parent_last_name, :password, :password_confirmation, :event_id, :is_active, :is_site_sales_admin, :is_take_orders_admin, :is_online_sales_admin, :is_admin, :is_super_admin, :is_prizes_admin, :password_digest, :unit_id)
    end
end
