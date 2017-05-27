class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_scout!
  before_action :set_event, if: Proc.new { |n| current_scout }
  before_action :set_unit, if: Proc.new { |n| current_scout }
  before_action :authorize
  before_action :create_an_event!, if: Proc.new { |n| current_scout && current_scout.is_unit_admin? && !@active_event }
  before_action :need_an_event!, if: Proc.new { |n| current_scout && !current_scout.is_admin? && current_scout.event_id.nil? }

  def set_unit
    if current_scout
      @unit = current_scout.unit
    end
  end

  def set_event
    if @active_event = current_scout.event
      cookies[:event_id] = current_scout.event_id
    end
  end

  def current_scout
    @current_scout
  end

  def authorize
    redirect_to root_path unless current_scout
  end

  def authorize_admin
    redirect_to home_path unless current_scout.is_admin?
  end

  def authorize_unit_admin
    redirect_to home_path unless current_scout.is_unit_admin?
  end

  def authorize_online_admin
    redirect_to home_path unless current_scout.is_online_sales_admin?
  end

  def authorize_site_sales_admin
    redirect_to home_path unless current_scout.is_site_sales_admin?
  end

  def authorize_take_orders_admin
    redirect_to home_path unless current_scout.is_take_orders_admin?
  end

  def authorize_prizes_admin
    redirect_to home_path unless current_scout.is_prizes_admin?
  end

  def authorize_warehouse_admin
    redirect_to home_path unless current_scout.is_warehouse_admin?
  end

  def authorize_financial_admin
    redirect_to home_path unless current_scout.is_financial_admin?
  end

  private

  def need_an_event!
    flash[:alert] = "No Event is currently selected."
  end

  def create_an_event!
    redirect_to new_event_path unless ['events', 'sessions'].include? controller_name
  end

  def authenticate_scout!
    @current_scout ||= Scout.find(session[:scout_id]) if session[:scout_id] rescue nil
  end
end