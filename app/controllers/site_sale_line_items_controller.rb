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

  def create
    @line_item = @site_sale.site_sale_line_items.build(site_sale_line_item_params)

    if @line_item.save
      redirect_to @site_sale, notice: 'Product sold was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    if @line_item.update(site_sale_line_item_params)
      redirect_to @site_sale, notice: "#{@line_item.product.name} was successfully updated."
    else
      redirect_to @site_sale, alert: "The following errors occurred: #{@line_item.errors.full_messages.join(",")}"
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    if @line_item.destroy
      redirect_to @site_sale, notice: "#{@line_item.product.name} was successfully destroyed."
    else
      redirect_to @site_sale, alert: "There was a problem destroying #{@line_item.product.name}."
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
