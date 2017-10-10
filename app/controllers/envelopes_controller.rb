class EnvelopesController < ApplicationController
  before_action :set_envelope, only: [:show, :edit, :update, :destroy]
  before_action :authorize_take_orders_admin, except: [:show, :remove_take_order]

  def index
    @envelopes = @active_event.envelopes.order(closed_at: :desc).page(params[:page])

    unless current_scout.admin?
      @envelopes = @envelopes.where(scout_id: current_scout)
    end

    if params[:status] == 'open'
      @envelopes = @envelopes.open
    elsif params[:status] == 'closed'
      @envelopes = @envelopes.closed
    end
  
    @take_orders = @envelopes.joins(take_orders: :take_order_line_items)
    @total_sales = @take_orders.sum(:value)
    @total_bsa_product = @envelopes.joins(take_orders: [take_order_line_items: :product]).where("products.is_sourced_from_bsa = ?", true).sum(:value)
    @total_pack_donations = @envelopes.joins(take_orders: [take_order_line_items: :product]).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def show
    @take_orders = @envelope.take_orders.order(:created_at)
    @payment_methods = @take_orders.joins(:account).group('accounts.name', 'take_orders.id')
  end

  def new
    @envelope = Envelope.new
    @scouts = @unit.scouts.active.not_admin.order(:last_name)
  end

  def edit
  end

  def close
    @envelope = Envelope.find(params[:id])
    @envelope.update(status: 'Closed', closed_by: current_scout.id)
    redirect_to envelope_path(@envelope)
  end

  def open
    @envelope = Envelope.find(params[:id])
    @envelope.update(status: 'Open', closed_by: nil)
    redirect_to envelope_path(@envelope)
  end

  def picked_up
    @envelope = Envelope.find(params[:id])
    @envelope.update(product_picked_up_at: Time.now, status: 'Picked Up')
    redirect_to envelope_path(@envelope)
  end

  def remove_take_order
    take_order = TakeOrder.find(params[:id])
    if take_order.envelope.scout == current_scout || current_scout.is_take_order_admin?
      take_order.destroy
    end
    @envelope = Envelope.find(params[:envelope_id])
    redirect_to envelope_path(@envelope.id)
  end

  def create
    @envelope = Envelope.new(envelope_params)
    @envelope.created_by = current_scout.id
    @envelope.event_id = @active_event.id

    if @envelope.save
      redirect_to envelope_path(@envelope), notice: 'Envelope was successfully created.'
    else
      render :new
    end
  end

  def update
    if @envelope.update(envelope_params)
      redirect_to @envelope, notice: 'Envelope was successfully updated.'
    else
      render :edit
    end
  end

  def assign
    @envelope = Envelope.find(params[:envelope_id]) if params[:envelope_id]
    params[:take_orders].each do |take_order_id|
      TakeOrder.find(take_order_id).update(envelope_id: @envelope.id)
    end
    redirect_to envelope_path(@envelope)
  end

  def destroy
    @envelope.destroy
    redirect_to take_orders_path
  end

  private
    def set_envelope
      if current_scout.is_admin?
        @envelope = @active_event.envelopes.find(params[:id]) if params[:id]
      else
        @envelope = current_scout.envelopes.find(params[:id]) if params[:id]
      end        
    end

    def envelope_params
      params.require(:envelope).permit(:scout_id, :event_id, :status)
    end
end
