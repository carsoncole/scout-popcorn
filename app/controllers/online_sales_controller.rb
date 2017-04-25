class OnlineSalesController < ApplicationController
  before_action :set_online_sale, only: [:show, :edit, :update, :destroy]

  def index
    if current_scout.admin?
      @online_sales = @active_event.online_sales.order(order_date: :asc)
    else
      @online_sales = @active_event.online_sales.where(scout_id: current_scout.id).order(order_date: :asc)
    end
  end

  def show
  end

  def new
    @online_sale = @active_event.online_sales.build
  end

  def edit
  end

  def create
    @online_sale = @active_event.online_sales.build(online_sale_params)

    if @online_sale.save
      redirect_to online_sales_path, notice: 'Online sale was successfully created.'
    else
      render :new
    end
  end

  def update
    if @online_sale.update(online_sale_params)
      redirect_to online_sales_path, notice: 'Online sale was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @online_sale.destroy
    redirect_to online_sales_url, notice: 'Online sale was successfully destroyed.'
  end

  private
    def set_online_sale
      @online_sale = OnlineSale.find(params[:id])
    end

    def online_sale_params
      params.require(:online_sale).permit(:scout_id, :event_id, :order_date, :customer_name, :description, :amount)
    end
end
