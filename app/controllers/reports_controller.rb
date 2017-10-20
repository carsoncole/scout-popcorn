class ReportsController < ApplicationController
  before_action :authorize_admin, only: :summary

  def summary
    @take_order_sales_turned_in = @active_event.total_take_order_sales(true)
    @online_sales = @active_event.total_online_sales
    @site_sale_sales = @active_event.total_site_sale_sales
    @total_sales = @active_event.total_sales
  end

end