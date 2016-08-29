class DirectSalesController < ApplicationController
  before_action :set_direct_sale, only: [:show, :edit, :update, :destroy]

  def index
    @direct_sales = DirectSale.order(created_at: :desc).page(params[:page])
    @direct_sales = @direct_sales.where(event_id: @active_event) if @active_event
    @direct_sales = @direct_sales.where(scout_id: current_scout) unless current_scout.is_admin?
  end

  # GET /direct_sales/1
  # GET /direct_sales/1.json
  def show
  end

  # GET /direct_sales/new
  def new
    @direct_sale = @active_event.direct_sales.build
    @direct_sale.scout_id = current_scout.id unless current_scout.is_admin?
  end

  # GET /direct_sales/1/edit
  def edit
  end

  # POST /direct_sales
  # POST /direct_sales.json
  def create
    @direct_sale = @active_event.direct_sales.build(direct_sale_params)
    @direct_sale.scout_id = current_scout.id unless current_scout.is_admin?
    @direct_sale.price = @direct_sale.product.retail_price

    respond_to do |format|
      if @direct_sale.save
        format.html { redirect_to direct_sales_path, notice: 'Direct sale was successfully created.' }
        format.json { render :show, status: :created, location: @direct_sale }
      else
        format.html { render :new }
        format.json { render json: @direct_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /direct_sales/1
  # PATCH/PUT /direct_sales/1.json
  def update
    if params[:paid]
      @direct_sale.update(status: :paid)
    else 
      @direct_sale.update(direct_order_params)
    end
    redirect_to direct_sales_path, notice: 'Direct sale was successfully updated.'
  end

  # DELETE /direct_sales/1
  # DELETE /direct_sales/1.json
  def destroy
    @direct_sale.destroy
    respond_to do |format|
      format.html { redirect_to direct_sales_url, notice: 'Direct sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_direct_sale
      @direct_sale = DirectSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def direct_sale_params
      params.require(:direct_sale).permit(:scout_id, :event_id, :product_id, :quantity, :amount)
    end
end
