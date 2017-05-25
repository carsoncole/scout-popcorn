class ScoutsController < ApplicationController
  before_action :set_scout, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create, :forgot_password]
  before_action :authorize_unit_admin, only: :destroy
  before_action :authorize_admin, only: :index
  # layout 'sessions', only: [:create, :forgot_password]

  def index
    # @inactive_scouts = @unit.scouts.inactive
    @scouts = @unit.scouts.active.not_admin.order(:first_name)
    @administrators = @unit.scouts.active.admin
  end

  def show
  end

  def new
    redirect_to root_path if Unit.active.empty?
    @scout = Scout.new
    @units = Unit.active.order(:name)
  end

  def edit
  end

  def create
    @scout = Scout.new(scout_params)
    @scout.email = @scout.email.downcase

    if current_scout && @scout.save
      redirect_to root_path, notice: 'The account was successfully created.'
    elsif @scout.save
      redirect_to root_path, notice: 'Your account was successfully created. Please login to continue'
    else
      @units = Unit.active.order(:name)
      render :new
    end

  end

  def update_password
    @scout = @unit.scouts.find(params[:scout_id])
  end

  def update
    if ( current_scout.is_unit_admin || current_scout == @scout ) && @scout.update(scout_params)
      redirect_to @scout, notice: 'Scout was successfully updated.'
    else
      render :edit, notice: 'Scout was not updated.'
    end
  end

  def destroy
    if @scout.activity?
      message = 'This Scout can not be destroyed since it has activity.'
    else
      @scout.destroy
      if @scout.admin?
        message = 'Administrator account was successfully destroyed.'
      else
        message = 'Scout account was successfully destroyed.'
      end
    end
    redirect_to scouts_path, notice: message
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

    def scout_params
      params.require(:scout).permit(:first_name, :last_name, :email, :password, :password_confirmation, :event_id, :is_active, :is_site_sales_admin, :is_take_orders_admin, :is_online_sales_admin, :is_admin, :is_unit_admin, :is_financial_admin, :is_prizes_admin, :is_warehouse_admin, :password_digest, :unit_id)
    end
end
