class TakeOrderLineItemsController < ApplicationController
  before_action :set_take_order
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  def index
    @line_items = @take_order.take_order_line_items
  end

  def show
  end

  def new
    @line_item = TakeOrderLineItem.new
  end

  def edit
  end

  def create
    @line_item = @take_order.take_order_line_items.build(take_order_line_item_params)

    if @line_item.save
      redirect_to @take_order, notice: 'Product was added to the Take Order'
    else
      render :new
    end
  end

  def update
    if @line_item.update(take_order_line_item_params)
      redirect_to @take_order, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @line_item.destroy
    redirect_to @take_order, notice: 'Item was successfully destroyed.'
  end

  private
    def set_line_item
      @line_item = @take_order.take_order_line_items.find(params[:id])
    end

    def set_take_order
      @take_order = TakeOrder.find(params[:take_order_id]) if params[:take_order_id]
    end

    def take_order_line_item_params
      params.require(:take_order_line_item).permit(:take_order_id, :product_id, :quantity)
    end
end
