class TakeOrderLineItemsController < ApplicationController
  before_action :set_take_order
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = @take_order.take_order_line_items
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = TakeOrderLineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = @take_order.take_order_line_items.build(take_order_line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @take_order, notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(take_order_line_item_params)
        format.html { redirect_to @take_order, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to order_url(@take_order), notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = @take_order.take_order_line_items.find(params[:id])
    end

    def set_take_order
      @take_order = TakeOrder.find(params[:take_order_id]) if params[:take_order_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def take_order_line_item_params
      params.require(:take_order_line_item).permit(:take_order_id, :product_id, :quantity)
    end
end
