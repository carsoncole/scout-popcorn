class UnitsController < ApplicationController
  helper StatesHelper
  before_action :set_unit, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:new, :create]
  before_action :authorize_unit_admin, only: [:edit, :update, :destroy]

  def show
    cookies[:unit_id] = @unit.id
  end

  def new
    @unit = Unit.new
    # @unit.scouts.build
    @scout = Scout.new
  end

  def edit
  end

  def create
    @unit = Unit.new(unit_params)
    @scout = Scout.new(scout_params)
    @scout.valid?
    @scout.errors.delete(:unit_id)
    @scout.errors.delete(:unit)
    if !@scout.errors.any? && @unit.save
      @scout = @unit.scouts.new(first_name: scout_params[:first_name], last_name: scout_params[:last_name], unit_id: @unit.id, email: scout_params[:email], password:  scout_params[:password], password_confirmation: scout_params[:password_confirmation], is_unit_admin: true)
      if @scout.save
        @scout.assign_full_rights!
        redirect_to root_path, notice: 'Unit was successfully created. Login to continue.'
      else
        render :new, notice: @scout.errors.full_messages
      end
    else
      render :new, notice: @unit.errors.full_messages
    end
  end

  def update
    if @unit.update(unit_params)
      redirect_to @unit, notice: 'Unit was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @unit.destroy
    redirect_to root_url, notice: 'Unit was successfully destroyed.'
  end

  private
    def set_unit
      @unit = Unit.find(params[:id])
    end

    def unit_params
      params.require(:unit).permit(:name, :street_address_1, :street_address_2, :city, :zip_code, :state_postal_code, :treasurer_first_name, :treasurer_last_name, :treasurer_email, :first_name, :last_name, :email, :send_email_on_registration, :send_emails)
    end

    def scout_params
      params.require(:scout).permit( :password, :password_confirmation, :first_name, :last_name, :email )
    end
end

