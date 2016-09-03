class SiteSalesController < ApplicationController
  before_action :set_site_sale, only: [:show, :edit, :update, :destroy]

  # GET /site_sales
  # GET /site_sales.json
  def index
    @site_sales = SiteSale.order(:name).page(params[:page])
    @site_sales = @site_sales.where(event_id: @active_event) if @active_event
  end

  def show
    @line_items = @site_sale.site_sale_line_items.order(created_at: :desc)
    @scout_site_sales = @site_sale.scout_site_sales.joins(:scout).order("scouts.first_name ASC")
    @total_sales = @site_sale.site_sale_line_items.sum(:value)
  end

  def new
    @site_sale = @active_event.site_sales.new
  end

  def edit
  end

  def create
    @site_sale = @active_event.site_sales.build(site_sale_params)

    respond_to do |format|
      if @site_sale.save
        format.html { redirect_to @site_sale, notice: 'Site sale was successfully created.' }
        format.json { render :show, status: :created, location: @site_sale }
      else
        format.html { render :new }
        format.json { render json: @site_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:closed] && current_scout.is_admin?
      @site_sale.update(status: :closed)
    else 
      @site_sale.update(site_sale_params)
    end
    redirect_to @site_sale, notice: 'Take Order was successfully updated.'
  end

  def destroy
    @site_sale.destroy
    respond_to do |format|
      format.html { redirect_to site_sales_url, notice: 'Site sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_sale
      @site_sale = SiteSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_sale_params
      params.require(:site_sale).permit(:event_id, :name, :total_sales)
    end
end
