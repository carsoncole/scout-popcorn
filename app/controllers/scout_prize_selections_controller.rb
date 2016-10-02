class ScoutPrizeSelectionsController < ApplicationController
  def index
    @scout_prizes = @active_event.scout_prizes
  end
end
