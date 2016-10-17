class TakeOrdersOrderController < ApplicationController
  def index
    @submitted_take_orders = @active_event.take_orders.submitted
    @products_to_order = @submitted_take_orders.includes(take_order_line_items: :product).group(:product_id).sum('take_order_line_items.quantity')
  end
end
