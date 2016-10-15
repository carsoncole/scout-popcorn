class ScoutSiteSalesController < ApplicationController
  before_action :set_scout_site_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_site_sale

  # GET /scout_site_sales
  # GET /scout_site_sales.json
  def index
    @scout_site_sales = @active_event.scout_site_sales.order('site_sales.name')
    @scout_site_sales = @site_sales.where(scout_id: current_scout) unless current_scout.admin?
  end

  # GET /scout_site_sales/1
  # GET /scout_site_sales/1.json
  def show
  end

  # GET /scout_site_sales/new
  def new
    @scout_site_sale = ScoutSiteSale.new(site_sale_id: params[:site_sale_id])
    @scouts_in_site_sale = @site_sale.scout_site_sales.map{|ss| ss.scout_id}
    puts "*"*80
    puts @scouts_in_site_sale = @site_sale.scout_site_sales.map{|ss| ss.scout_id}
    puts @scouts_in_site_sale.class
    @site_sale_open_scouts = @unit.scouts.where.not(id: @scouts_in_site_sale).where(is_admin: nil)
    puts @site_sale_open_scouts
  end

  # GET /scout_site_sales/1/edit
  def edit
  end

  # POST /scout_site_sales
  # POST /scout_site_sales.json
  def create
    @scout_site_sale = @site_sale.scout_site_sales.build(scout_site_sale_params)

    respond_to do |format|
      if @scout_site_sale.save
        format.html { redirect_to @site_sale, notice: 'Scout site sale was successfully created.' }
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
        format.html { redirect_to @site_sale, notice: 'Scout site sale was successfully updated.' }
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
      format.html { redirect_to @site_sale, notice: 'Scout site sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_sale
      @site_sale = SiteSale.find(params[:site_sale_id]) if params[:site_sale_id]
    end

    def set_scout_site_sale
      @scout_site_sale = ScoutSiteSale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scout_site_sale_params
      params.require(:scout_site_sale).permit(:scout_id, :site_sale_id, :hours_worked)
    end
end
