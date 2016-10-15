class ApplicationController < ActionController::Base
  # layout :layout_by_resource

  protect_from_forgery with: :exception
  before_action :authenticate_scout!
  before_action :set_event, if: Proc.new {|n| current_scout }
  before_action :set_unit,if: Proc.new {|n| current_scout }


  def redirect_unless_admin!
    redirect_to root_path unless current_scout.admin?
  end

  private

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
    if @active_event = current_scout.default_event
      cookies[:event_id] = current_scout.default_event_id
    end
  end
end

