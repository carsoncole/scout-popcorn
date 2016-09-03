class TakeOrdersController < ApplicationController
  before_action :set_take_order, only: [:show, :edit, :update, :destroy]
  before_action :set_page_title, only: [:show, :new, :edit]

  # GET /orders
  # GET /orders.json
  def index
    @take_orders = TakeOrder.order(:status).page(params[:page])
    @take_orders = @take_orders.where(event_id: @active_event.id) if @active_event
    @take_orders = @take_orders.where(scout_id: current_scout) unless current_scout.is_admin?

    if params[:scout_id]
      @take_orders = @take_orders.where(scout_id: params[:scout_id])
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @take_order = TakeOrder.find(params[:id])
    @line_items = @take_order.take_order_line_items
  end

  # GET /orders/new
  def new
    @take_order = TakeOrder.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @take_order = TakeOrder.new(take_order_params)
    unless current_scout.is_admin?
      @take_order.scout_id = current_scout.id
    end
    @take_order.event_id = @active_event.id if @active_event

    respond_to do |format|
      if @take_order.save
        format.html { redirect_to @take_order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @take_order }
      else
        format.html { render :new }
        format.json { render json: @take_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if params[:submitted] && current_scout.is_admin?
      @take_order.update(status: :submitted, money_received_by_id: current_scout.id, money_received_at: Time.now)
    else 
      @take_order.update(take_order_params)
    end
    redirect_to @take_order, notice: 'Take Order was successfully updated.'
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @take_order.destroy
    respond_to do |format|
      format.html { redirect_to take_orders_url, notice: 'Take Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_take_order
      @take_order = TakeOrder.find(params[:id])
    end

    def set_page_title
      @page_title = "Take Order"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def take_order_params
      params.require(:take_order).permit(:scout_id, :submitted, :status_id, :customer_name, :customer_address, :customer_email)
    end
end
