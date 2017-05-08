class HomeController < ApplicationController

  def index
    if @active_event

      # TOP SELLERS
      take_order_sales_totals = TakeOrder.sales_by_scout_and_event(@active_event)
      site_sales_totals = SiteSale.sales_by_scout_and_event(@active_event)

      @scout_hash = {}
      [take_order_sales_totals, site_sales_totals].each do |sales_total|
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
        break if @top_sellers.count == @active_event.number_of_top_sellers && seller[1] < @top_sellers.last[1]
        @top_sellers << seller
      end
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
        @site_sale_sales = current_scout.total_site_sales( @active_event )
        @online_sales = current_scout.total_online_sales(@active_event)
        @total_sales = current_scout.total_sales(@active_event)
      end

      @prizes = @active_event.prizes.order(sales_amount: :asc).limit(10)
    end
  end

  def invite_scouts
  end

end