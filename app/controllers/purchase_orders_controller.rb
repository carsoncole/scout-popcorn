class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy]
  before_action :authorize_unit_admin

  def index
    @purchase_orders = PurchaseOrder.order(created_at: :desc)
    @purchase_orders = @purchase_orders.where(event_id: @active_event) if @active_event
  end

  def show
    @page_title = 'Purchase Order'
    @take_orders = @purchase_order.take_orders.order("take_orders.envelope_id")
    if @active_event
      @products = @active_event.products.where(is_sourced_from_bsa: true).order(:name)
    else
      @products = Product.order(:name)
    end
  end

  def new
    @purchase_order = PurchaseOrder.new
  end

  def edit
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)

    if @purchase_order.save
      redirect_to @purchase_order, notice: 'Purchase order was successfully created.'
    else
      render :new
    end
  end

  def update
    if params[:ordered]
      @purchase_order.update(status: :ordered)
    else 
      @purchase_order.update(purchase_order_params)
    end
    redirect_to @purchase_order, notice: 'Order was successfully updated.'
  end

  def destroy
    @purchase_order.destroy
    redirect_to purchase_orders_url, notice: 'Purchase order was successfully destroyed.'\
  end

  private
    def set_purchase_order
      if @active_event
        @purchase_order = @active_event.purchase_orders.find(params[:id])
      else
        @purchase_order = PurchaseOrder.find(params[:id])
      end
    end

    def purchase_order_params
      params.require(:purchase_order).permit(:unit_id)
    end
end