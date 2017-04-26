class TakeOrdersController < ApplicationController
  before_action :set_take_order, only: [:show, :edit, :update, :destroy]
  before_action :set_page_title, only: [:show, :new, :edit]

  # GET /orders
  # GET /orders.json
  def index
    # @take_orders = TakeOrder.order(created_at: :desc).page(params[:page])
    # @take_orders = @take_orders.where(event_id: @active_event.id) if @active_event
    # @take_orders = @take_orders.where(scout_id: current_scout) unless current_scout.admin?
    # @unassigned_take_orders = TakeOrder.loose.order(created_at: :desc)

    # if params[:scout_id]
    #   @take_orders = @take_orders.where(scout_id: params[:scout_id])
    # end

    # if params[:filter] == 'loose'
    #   @take_orders = @take_orders.loose

    # elsif params[:filter]
    #   @take_orders = @take_orders.where(status: params[:filter])
    # end

    if current_scout.admin?
      @envelopes = @active_event.envelopes
    else
      @envelopes = @active_event.envelopes.where(scout_id: current_scout.id).order(status: :desc, closed_at: :desc)
    end

    if params[:envelopes] == 'open' || params[:envelopes].blank?
      @envelopes = @envelopes.open
    elsif params[:envelopes]  == 'closed'
      @envelopes = @envelopes.closed
    elsif params[:envelopes]  == 'picked-up'
      @envelopes = @envelopes.picked_up
    end

    if params[:scout_id]
      @envelopes = @envelopes.where(scout_id: params[:scout_id])
    end

    if params[:pick_sheet]
      @envelopes = @active_event.envelopes.includes(take_orders: [take_order_line_items: :product]).closed
      render :pick_sheet
    end

  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @take_order = @active_event.take_orders.find(params[:id])
    @line_items = @take_order.take_order_line_items
  end

  # GET /orders/new
  def new
    @take_order = TakeOrder.new
    @take_order.envelope_id = params[:envelope_id] if params[:envelope_id]
    @take_order.scout_id = params[:scout_id] if params[:scout_id]
    @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
  end

  # GET /orders/1/edit
  def edit
    @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
    @open_envelopes = @active_event.envelopes.open
  end

  # POST /orders
  # POST /orders.json
  def create
    @take_order = TakeOrder.new(take_order_params)
    @take_order.status = 'in hand'
    unless @take_order.scout_id
      @envelope = Envelope.find(params[:take_order][:envelope_id])
      if current_scout.admin?
        @take_order.scout_id = @envelope.scout_id if @envelope
      else
        @take_order.scout_id = current_scout.id
      end
    end


    @take_order.event_id = @active_event.id if @active_event

    respond_to do |format|
      if @take_order.save
        format.html { redirect_to @take_order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @take_order }
      else
        @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
        format.html { render :new }
        format.json { render json: @take_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if params[:submitted] && current_scout.admin?
      @take_order.update(status: :submitted, money_received_by_id: current_scout.id, money_received_at: Time.current)
    else 
      @take_order.update(take_order_params)
    end
    redirect_to take_orders_path, notice: 'Take Order was successfully updated.'
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
      @take_order = @active_event.take_orders.find(params[:id])
    end

    def set_page_title
      @page_title = "Take Order"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def take_order_params
      params.require(:take_order).permit(:scout_id, :submitted, :status_id, :customer_name, :customer_address, :customer_email, :is_paid_by_credit_card, :credit_card_order_number, :payment_account_id, :square_reciept_url, :envelope_id, :note)
    end
end
