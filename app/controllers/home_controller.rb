class HomeController < ApplicationController

  def index
    if @active_event

      @top_sellers = @active_event.sales_by_scout_ordered[0..(@active_event.number_of_top_sellers-1)]
      @resources = @active_event.resources
    

      # Site Sales
      @site_sales = @active_event.upcoming_site_sales


      if current_scout.is_admin?
        # _my_sales - admin
        @take_order_sales_turned_in = @active_event.total_take_order_sales(true)
        @take_order_sales_not_turned_in = @active_event.total_take_order_sales(false)
        @online_sales = @active_event.total_online_sales
        @site_sale_sales = @active_event.total_site_sale_sales
        @total_sales = @active_event.total_sales
        
        @site_sales_cash = Ledger.joins(:account).where('accounts.id = ?', Account.site_sale(@active_event).id).sum('ledgers.amount') if current_scout.is_site_sales_admin?
        @take_orders_cash = Ledger.joins(:account).where('accounts.id = ?', Account.take_order(@active_event).id).sum('ledgers.amount') if current_scout.is_take_orders_admin?
      else
        # _my_sales
        @take_order_sales_turned_in = current_scout.total_take_order_sales( @active_event, true )
        @take_order_sales_not_turned_in = current_scout.total_take_order_sales( @active_event, false )
        @site_sale_sales = @active_event.total_site_sale_sales(current_scout, true)
        @online_sales = current_scout.total_online_sales(@active_event)
        @total_sales = current_scout.total_sales(@active_event)
      end

      @prizes = @active_event.prizes.order(sales_amount: :asc).limit(10)
    end
  end

  def invite_scouts
  end

end