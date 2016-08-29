class TopSellersController < ApplicationController


  def index
    top_sellers_hash = @active_event.take_orders.paid.joins(:line_items, :scout).group(:scout_id).sum(:value)
    @top_sellers_hash = top_sellers_hash.sort_by {|id, value| value }
  end

end