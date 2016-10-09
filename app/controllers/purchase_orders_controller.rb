class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy]

  def index
    @purchase_orders = PurchaseOrder.order(created_at: :desc)
    @purchase_orders = @purchase_orders.where(event_id: @active_event) if @active_event
  end

  def show
    @page_title = 'Purchase Order'
    @take_orders = @purchase_order.take_orders
    if @active_event
      @products = @active_event.products.where(is_sourced_from_bsa: true).order(:name)
    else
      @products = Product.order(:name)
    end
  end

  # GET /purchase_orders/new
  def new
    @purchase_order = PurchaseOrder.new
  end

  # GET /purchase_orders/1/edit
  def edit
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)

    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_order }
      else
        format.html { render :new }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_orders/1
  # PATCH/PUT /purchase_orders/1.json
  def update
    if params[:ordered]
      @purchase_order.update(status: :ordered)
    else 
      @purchase_order.update(purchase_order_params)
    end
    redirect_to @purchase_order, notice: 'Order was successfully updated.'
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to purchase_orders_url, notice: 'Purchase order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order
      if @unit
        @purchase_order = @unit.purchase_orders.find(params[:id])
      else
        @purchase_order = PurchaseOrder.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_params
      params.require(:purchase_order).permit(:unit_id)
    end
end
