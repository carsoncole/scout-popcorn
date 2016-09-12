class TopSellersController < ApplicationController


  def index
    take_order_sales_totals = TakeOrder.sales_by_scout_and_event(@active_event)
    direct_sales_totals = DirectSale.sales_by_scout_and_event(@active_event)
    site_sales_totals = SiteSale.sales_by_scout_and_event(@active_event)

    @scout_hash = {}
    [take_order_sales_totals, direct_sales_totals, site_sales_totals].each do |sales_total|
      sales_total.each do |scout, amount|
        if @scout_hash[scout]
          @scout_hash[scout] += amount
        else
          @scout_hash[scout] = amount
        end
      end
    end

    @top_sellers_full_list = @scout_hash.sort{|a,b| a[1] <=> b[1]}.reverse

    @top_sellers = []
    @top_sellers_full_list.each do |seller|
      break if @top_sellers.count == 5 && seller[1] < @top_sellers.last[1]
      @top_sellers << seller
    end

    # top_sellers_hash = @active_event.take_orders.submitted.joins(:take_order_line_items, :scout).group(:scout_id).sum(:value)
    # @top_sellers_hash = top_sellers_hash.sort_by {|id, value| value }
  end

end