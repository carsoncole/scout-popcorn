class HomeController < ApplicationController

  def index
    @events = @unit.events.active
  end

end