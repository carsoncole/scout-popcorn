class HomeController < ApplicationController

  def index
    @events = @unit.events.active
    @pack_donations = SiteSaleLineItem.joins(:product, :site_sale).where("site_sales.event_id = ?", @active_event.id).where("products.name = ?",'Pack Donation').sum(:value)
    @product_sales = SiteSaleLineItem.joins(:product, :site_sale).where("site_sales.event_id = ?", @active_event.id).where("products.name <> ?",'Pack Donation').sum(:value)
  

    # TOP SELLERS
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
  end

end