class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_scout!
  before_action :set_event, if: Proc.new {|n| current_scout }
  before_action :set_unit,if: Proc.new {|n| current_scout }
  before_action :authorize


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


  def authenticate_scout!
    @current_scout ||= Scout.find(session[:scout_id]) if session[:scout_id]
  end
end