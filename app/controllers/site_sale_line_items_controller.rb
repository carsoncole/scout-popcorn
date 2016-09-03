class SiteSaleLineItemsController < ApplicationController
  before_action :set_site_sale
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = @site_sale.site_sale_line_items
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = @site_sale.site_sale_line_items.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = @site_sale.site_sale_line_items.build(site_sale_line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @site_sale, notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(site_sale_line_item_params)
        format.html { redirect_to @site_sale, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to order_url(@site_sale), notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = @site_sale.site_sale_line_items.find(params[:id])
    end

    def set_site_sale
      @site_sale = SiteSale.find(params[:site_sale_id]) if params[:site_sale_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_sale_line_item_params
      params.require(:site_sale_line_item).permit(:site_sale_id, :product_id, :quantity)
    end
end
