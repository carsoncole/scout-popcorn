class ScoutSiteSalesController < ApplicationController
  before_action :set_scout_site_sale, only: [:show, :edit, :update, :destroy]

  # GET /scout_site_sales
  # GET /scout_site_sales.json
  def index
    @scout_site_sales = @active_event.scout_site_sales.order('site_sales.name')
    @scout_site_sales = @site_sales.where(scout_id: current_scout) unless current_scout.is_admin?
  end

  # GET /scout_site_sales/1
  # GET /scout_site_sales/1.json
  def show
  end

  # GET /scout_site_sales/new
  def new
    @scout_site_sale = ScoutSiteSale.new
  end

  # GET /scout_site_sales/1/edit
  def edit
  end

  # POST /scout_site_sales
  # POST /scout_site_sales.json
  def create
    @scout_site_sale = ScoutSiteSale.new(scout_site_sale_params)

    respond_to do |format|
      if @scout_site_sale.save
        format.html { redirect_to @scout_site_sale, notice: 'Scout site sale was successfully created.' }
        format.json { render :show, status: :created, location: @scout_site_sale }
      else
        format.html { render :new }
        format.json { render json: @scout_site_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scout_site_sales/1
  # PATCH/PUT /scout_site_sales/1.json
  def update
    respond_to do |format|
      if @scout_site_sale.update(scout_site_sale_params)
        format.html { redirect_to @scout_site_sale, notice: 'Scout site sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @scout_site_sale }
      else
        format.html { render :edit }
        format.json { render json: @scout_site_sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scout_site_sales/1
  # DELETE /scout_site_sales/1.json
  def destroy
    @scout_site_sale.destroy
    respond_to do |format|
      format.html { redirect_to scout_site_sales_url, notice: 'Scout site sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scout_site_sale
      @scout_site_sale = ScoutSiteSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scout_site_sale_params
      params.require(:scout_site_sale).permit(:scout_id, :site_sale_id, :hours_worked)
    end
end
