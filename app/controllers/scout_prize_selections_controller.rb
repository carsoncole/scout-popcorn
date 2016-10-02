class ScoutPrizeSelectionsController < ApplicationController
  def index
    @scout_prizes = @active_event.scout_prizes
    scout_ids_with_prizes = @scout_prizes.map{|sp| sp.scout_id}.uniq
    @scouts_without_prizes = @unit.scouts.map {|scout| scout if scout.total_sales(@active_event) > 0 && !scout_ids_with_prizes.include?(scout.id) }.compact
  end

end
