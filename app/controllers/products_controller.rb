class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_unit_admin, except: :index

  def index
    if params[:collection_name]
      @products = Product.default.where(sourced_from: params[:collection_name]).order(:name)
    else
      @products = @active_event.products.order(:name)
    end

    if params[:inactive] == 'true'
      @products = @products.where(is_active: false)
    else
      @products = @products.active
    end
    @presets = Product.default.select(:sourced_from).group(:sourced_from)
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

  def preset_collections
    @presets = Product.default.group(:sourced_from)
  end

  def add_preset_collection
    products_to_add = Product.default.where(sourced_from: params[:collection_name])
    initial_product_count = @active_event.products.size
    products_to_add.each do |product|
      @active_event.products.create(product.attributes.except("id", "created_at", "updated_at"))
    end
    post_product_count = @active_event.reload.products.size
    products_added_count = post_product_count - initial_product_count
    if products_added_count == products_to_add.size
      redirect_to products_path, notice: 'All of the products were added to your Event.'
    else
      redirect_to products_path, alert: "#{(products_added_count).to_s} #{"product".pluralize(products_added_count)} added to your Event. One or more may not have been added due to products with the same name in your Event."
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :quantity, :retail_price, :url, :is_physical_inventory, :is_pack_donation, :is_sourced_from_bsa, :is_active)
    end
end
