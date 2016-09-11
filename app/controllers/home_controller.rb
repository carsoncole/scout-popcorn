class HomeController < ApplicationController

  def index
    @events = @unit.events.active
    @pack_donations = SiteSaleLineItem.joins(:product, :site_sale).where("site_sales.event_id = ?", @active_event.id).where("products.name = ?",'Pack Donation').sum(:value)
    @product_sales = SiteSaleLineItem.joins(:product, :site_sale).where("site_sales.event_id = ?", @active_event.id).where("products.name <> ?",'Pack Donation').sum(:value)
  end

end