class TakeOrdersController < ApplicationController
  before_action :set_take_order, only: [:show, :edit, :update, :destroy]
  before_action :set_page_title, only: [:show, :new, :edit]

  def index
    if current_scout.admin?
      @envelopes = @active_event.envelopes
    else
      @envelopes = @active_event.envelopes.where(scout_id: current_scout.id).order(status: :desc, closed_at: :desc)
    end

    @open_envelopes = @envelopes.open
    @closed_envelopes = @envelopes.closed
    @picked_up_envelopes = @envelopes.picked_up

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

  def show
    @take_order = @active_event.take_orders.find(params[:id])
    @line_items = @take_order.take_order_line_items
  end

  def new
    @take_order = TakeOrder.new
    @take_order.envelope_id = params[:envelope_id] if params[:envelope_id]
    @take_order.scout_id = params[:scout_id] if params[:scout_id]
    @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
  end

  def edit
    @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
    @open_envelopes = @active_event.envelopes.open
  end

  def create
    @envelope = current_scout.open_envelope(@active_event)
    @take_order = @envelope.take_orders.new(take_order_params)
    @take_order.status = 'in hand'

    if @take_order.save
      redirect_to @take_order, notice: 'Customer details were entered.'
    else
      @accounts = @active_event.accounts.is_take_order_eligible.order(name: :desc)
      render :new
    end
  end

  def update
    if params[:submitted] && current_scout.admin?
      @take_order.update(status: :submitted, money_received_by_id: current_scout.id, money_received_at: Time.current)
    else 
      @take_order.update(take_order_params)
    end
    redirect_to @take_order, notice: 'Take Order was successfully updated.'
  end

  def destroy
    @take_order.destroy
      redirect_to take_orders_url, notice: 'Take Order was successfully destroyed.'
  end

  private
    def set_take_order
      @take_order = @active_event.take_orders.find(params[:id])
    end

    def set_page_title
      @page_title = "Take Order"
    end

    def take_order_params
      params.require(:take_order).permit( :submitted, :status, :customer_name, :customer_address, :customer_email, :is_paid_by_credit_card, :credit_card_order_number, :payment_account_id, :square_reciept_url, :envelope_id, :note)
    end
end
