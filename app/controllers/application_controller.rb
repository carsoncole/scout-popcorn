class ApplicationController < ActionController::Base
  # layout :layout_by_resource

  protect_from_forgery with: :exception
  before_action :authenticate_scout!
  before_action :set_unit, :set_event, if: Proc.new {|n| current_scout }

  private

  def set_unit
    if cookies[:unit_id]
      begin
        @unit = Unit.find(cookies[:unit_id]) 
      rescue
        cookies.delete :unit_id
      end
    elsif !current_scout.is_super_admin?
      @unit = current_scout.unit
    end
  end

  def set_event
    if @active_event = current_scout.default_event
      cookies[:event_id] = current_scout.default_event_id
    end
  end
end

