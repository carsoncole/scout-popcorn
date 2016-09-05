class OnlineSalesController < ApplicationController
  before_action :set_online_sale, only: [:show, :edit, :update, :destroy]

  # GET /online_sales
  # GET /online_sales.json
  def index
    @online_sales = OnlineSale.all
  end

  # GET /online_sales/1
  # GET /online_sales/1.json
  def show
  end

  # GET /online_sales/new
  def new
    @online_sale = OnlineSale.new
  end

  # GET /online_sales/1/edit
  def edit
  end

  # POST /online_sales
  # POST /online_sales.json
  def create
    @online_sale = OnlineSale.new(online_sale_params)

    respond_to do |format|
      if @online_sale.save
        format.html { redirect_to @online_sale, notice: 'Online sale was successfully created.' }
        format.json { render :show, status: :created, location: @online_sale }
      else
        format.html { render :new }
        format.json { render json: @online_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /online_sales/1
  # PATCH/PUT /online_sales/1.json
  def update
    respond_to do |format|
      if @online_sale.update(online_sale_params)
        format.html { redirect_to @online_sale, notice: 'Online sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @online_sale }
      else
        format.html { render :edit }
        format.json { render json: @online_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /online_sales/1
  # DELETE /online_sales/1.json
  def destroy
    @online_sale.destroy
    respond_to do |format|
      format.html { redirect_to online_sales_url, notice: 'Online sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_online_sale
      @online_sale = OnlineSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def online_sale_params
      params.require(:online_sale).permit(:scout_id, :event_id, :order_date, :customer_name, :description, :amount)
    end
end
