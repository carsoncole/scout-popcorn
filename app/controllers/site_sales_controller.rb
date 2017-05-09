class SiteSalesController < ApplicationController
  before_action :authorize_admin, except: :index
  before_action :set_site_sale, only: [:show, :edit, :update, :destroy]


  def index
    @site_sales = SiteSale.includes(:scout_site_sales, :site_sale_line_items).order(:date).page(params[:page])
    @site_sales = @site_sales.where(event_id: @active_event) if @active_event
  end

  def show
    @line_items = @site_sale.site_sale_line_items.order(created_at: :desc)
    @scout_site_sales = @site_sale.scout_site_sales.joins(:scout).order("scouts.first_name ASC")
    @total_sales = @site_sale.site_sale_line_items.sum(:value)
    @total_hours = @site_sale.scout_site_sales.sum(:hours_worked)
    @site_sale_payment_methods = @site_sale.site_sale_payment_methods
  end

  def new
    @site_sale = @active_event.site_sales.new
  end

  def edit
  end

  def create
    @site_sale = @active_event.site_sales.build(site_sale_params)

    if @site_sale.save
      redirect_to site_sales_path, notice: 'Site sale was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:closed] && current_scout.admin?
      if @site_sale.payments_balance?
        if @site_sale.update(closed_at: Time.now, closed_by: current_scout.id)
          redirect_to @site_sale, notice: 'The Site Sale was successfully closed.'
        else
          redirect_to @site_sale, alert: "The following errors occurred: #{@site_sale.errors.full_messages.join(",")}"
        end
      else
        redirect_to @site_sale, alert: 'Payment methods do not balance with sales receipts.'
      end
    elsif params[:open] && current_scout.admin?
      @site_sale.update(closed_at: nil, closed_by: nil)
      redirect_to @site_sale, notice: 'The Site Sale was re-opened.'
    else 
      @site_sale.update(site_sale_params)
      redirect_to @site_sale, notice: 'The Site Sale was successfully updated.'
    end 
  end

  def destroy
    @site_sale.destroy
    redirect_to site_sales_url, notice: 'Site sale was successfully destroyed.'
  end

  def tracking_sheet
    @site_sale = SiteSale.find(params[:site_sale_id])
    @products = @active_event.products.order(:name)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_sale
      @site_sale = SiteSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_sale_params
      params.require(:site_sale).permit(:event_id, :name, :date, :status)
    end
end
