class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks_query = @unit.stocks.joins(:product).order(:location, 'products.name')
    @locations = @unit.stocks.order(location: :desc).group(:location)
    if params[:location]
      @stocks_query = @stocks_query.where(location: params[:location])
    elsif params[:all]
      # use default
    elsif @locations.any?
      redirect_to stocks_path(location: @locations.first.location)
    end

    if params['date(1i)']
      @date = Date.new params['date(1i)'].to_i,params['date(2i)'].to_i, params['date(3i)'].to_i
      @stocks_query = @stocks_query.where("stocks.date <= ?", @date)
    end

    @stocks_hash = @stocks_query.group(:product_id, :location).sum(:quantity)
    @locations = @unit.stocks.order(location: :desc).group(:location)
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
    @products = @active_event.products.order(:name)
  end

  # GET /stocks/1/edit
  def edit
    @products = @active_event.products.order(:name)
  end

  def stock_movement
    @products = @active_event.products.order(:name)
  end

  def ledger
    @stocks = @unit.stocks.order(created_at: :desc).page(params[:page]).per(50)
    @stocks = @stocks.where(location: params[:location]) if params[:location]
    @stocks = @stocks.where(product_id: params[:product_id]) if params[:product_id]
    @locations = @unit.stocks.group(:location)
  end

  # POST /stocks
  # POST /stocks.json
  def create
    if stock_params[:movement_with_warehouse] && stock_params[:location] == 'warehouse'
      redirect_to stocks_ledger_path, notice: "Location needs to be different than -warehouse-"
    else
      if stock_params[:movement_with_warehouse] == "1"
        movement_with_warehouse = true
        stock_params.delete :movement_with_warehouse
        @corresponding_stock = @unit.stocks.build(stock_params)
        @corresponding_stock.quantity = - @corresponding_stock.quantity
        @corresponding_stock.location = 'warehouse'
        @corresponding_stock.created_by = current_scout.id
        @corresponding_stock.save
      end

      @stock = @unit.stocks.build(stock_params)
      @stock.created_by = current_scout.id

      if @stock.save
        redirect_to stocks_ledger_path, notice: 'Stock was successfully created.'
      else
        @products = @active_event.products.order(:name)
        render :new
      end
    end
  end 

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stocks_ledger_path, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_ledger_path, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:unit_id, :product_id, :quantity, :location, :description, :movement_with_warehouse, :is_transfer_from_bsa, :date)
    end
end
