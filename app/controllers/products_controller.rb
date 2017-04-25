class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = @active_event.products.order(:name)

    if params[:inactive] == 'true'
      @products = @products.where(is_active: false)
    else
      @products = @products.active
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    if @active_event
      @product = @active_event.products.build(product_params)
    else
      @product = Product.new(product_params)
    end

    if @product.save
      redirect_to products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :quantity, :retail_price, :short_name, :url, :is_physical_inventory, :is_pack_donation, :is_sourced_from_bsa, :is_active)
    end
end
