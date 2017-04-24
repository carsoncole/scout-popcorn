class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_scout!
  before_action :set_event, if: Proc.new {|n| current_scout }
  before_action :set_unit,if: Proc.new {|n| current_scout }
  before_action :authorize
  before_action :add_admin_messages!, if:  Proc.new { |n| current_scout && current_scout.is_admin? }
  before_action :create_an_event!, if: Proc.new { |n| current_scout && current_scout.is_admin? && !@active_event }
  before_action :need_an_event!, if: Proc.new { |n| current_scout && !current_scout.is_admin? && current_scout.event_id.nil? }


  def redirect_unless_admin!
    redirect_to root_path unless current_scout.admin?
  end

  def set_unit
    if current_scout
      @unit = current_scout.unit
    end
    # if cookies[:unit_id]
    #   begin
    #     @unit = Unit.find(cookies[:unit_id]) 
    #   rescue
    #     cookies.delete :unit_id
    #   end
    # else
    #   @unit = current_scout.unit
    # end
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

  private

  def logged_in?
    @current_scout ||= Scout.find(session[:scout_id]) if session[:scout_id]
  end

  helper_method :logged_in?

  def add_admin_messages!
    if current_scout.unit.events.empty?
      flash[:alert] = "Scouts can not currently sign up with your Unit, without an Event created. Add an Event to change this."
    elsif current_scout.unit.events.active.empty?
      flash[:alert] = "Scouts can not currently sign up with your Unit, without an active Event. Create an active Event, or un-archive an existing Event."
    end
  end

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