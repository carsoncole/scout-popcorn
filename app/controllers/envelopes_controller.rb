class EnvelopesController < ApplicationController
  before_action :set_envelope, only: [:show, :edit, :update, :destroy]

  # GET /envelopes
  # GET /envelopes.json
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

  # GET /envelopes/1p
  # GET /envelopes/1.json
  def show
    @take_orders = @envelope.take_orders.order(:created_at)
    @payment_methods = @take_orders.joins(:account).group('accounts.name')
  end

  # GET /envelopes/new
  def new
    @envelope = Envelope.new
    @scouts = @unit.scouts.active.not_admin.order(:last_name)
  end

  # GET /envelopes/1/edit
  def edit
  end

  def close
    @envelope = Envelope.find(params[:id])
    @envelope.update(status: 'Closed')#,money_received_by_id: current_scout.id, money_received_at: Time.current, closed_at: Time.current)
    redirect_to envelope_path(@envelope)
  end

  def open
    @envelope = Envelope.find(params[:id])
    @envelope.update(status: 'Open')#,money_received_by_id: nil, money_received_at: nil, closed_at: nil)
    redirect_to envelope_path(@envelope)
  end

  def picked_up
    @envelope = Envelope.find(params[:id])
    @envelope.update(product_picked_up_at: Time.now, status: 'Picked Up')#,money_received_by_id: nil, money_received_at: nil, closed_at: nil)
    redirect_to envelope_path(@envelope)
  end

  def remove_take_order
    take_order = TakeOrder.find(params[:id])
    take_order.destroy
    @envelope = Envelope.find(params[:envelope_id])
    redirect_to envelope_path(@envelope.id)
  end

  # POST /envelopes
  # POST /envelopes.json
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

  # PATCH/PUT /envelopes/1
  # PATCH/PUT /envelopes/1.json
  def update
    respond_to do |format|
      if @envelope.update(envelope_params)
        format.html { redirect_to @envelope, notice: 'Envelope was successfully updated.' }
        format.json { render :show, status: :ok, location: @envelope }
      else
        format.html { render :edit }
        format.json { render json: @envelope.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign
    @envelope = Envelope.find(params[:envelope_id]) if params[:envelope_id]
    params[:take_orders].each do |take_order_id|
      TakeOrder.find(take_order_id).update(envelope_id: @envelope.id)
    end
    redirect_to envelope_path(@envelope)
  end

  # DELETE /envelopes/1
  # DELETE /envelopes/1.json
  def destroy
    @envelope.destroy
    redirect_to take_orders_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_envelope
      @envelope = Envelope.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def envelope_params
      params.require(:envelope).permit(:scout_id, :event_id, :status)
    end
end
