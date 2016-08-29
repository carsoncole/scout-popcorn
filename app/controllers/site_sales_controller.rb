class SiteSalesController < ApplicationController
  before_action :set_site_sale, only: [:show, :edit, :update, :destroy]

  # GET /site_sales
  # GET /site_sales.json
  def index
    @site_sales = SiteSale.order(:name).page(params[:page])
    @site_sales = @site_sales.where(event_id: @active_event) if @active_event
  end

  # GET /site_sales/1
  # GET /site_sales/1.json
  def show
  end

  # GET /site_sales/new
  def new
    @site_sale = SiteSale.new
  end

  # GET /site_sales/1/edit
  def edit
  end

  # POST /site_sales
  # POST /site_sales.json
  def create
    @site_sale = SiteSale.new(site_sale_params)

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

  # PATCH/PUT /site_sales/1
  # PATCH/PUT /site_sales/1.json
  def update
    respond_to do |format|
      if @site_sale.update(site_sale_params)
        format.html { redirect_to @active_event.site_sales, notice: 'Site sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_sale }
      else
        format.html { render :edit }
        format.json { render json: @site_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_sales/1
  # DELETE /site_sales/1.json
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
