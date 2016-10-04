class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]

  # GET /prizes
  # GET /prizes.json
  def index
    @bsa_prizes = @active_event.prizes.bsa.order(:amount) if @active_event
    @pack_prizes = @active_event.prizes.pack.order(:amount)
    @bsa_bonus_prizes = @active_event.prizes.bsa_bonus.order(:amount)
  
    @total_sales = current_scout.total_sales(@active_event)
  end

  # GET /prizes/
  # GET /prizes/1.json
  def show
  end

  def cart
    Prize.process_bonus_prizes!(current_scout, @active_event) unless current_scout.is_admin?
    @total_sales = current_scout.total_sales(@active_event)
    @cart_prizes = current_scout.scout_prizes.where(event_id: @active_event.id).order(:prize_amount)
    @available_pack_prizes = @active_event.prizes.pack.where("amount <= ?", @total_sales).order(amount: :desc)
    @pack_prizes = @active_event.prizes.pack.where("amount <= ?", @total_sales).select("MAX(amount), *").group(:group)
    # @pack_prizes = @active_event.prizes.pack.where("amount < ?", @total_sales).order(amount: :desc)
    unless (@active_event.prizes.pack.map{|p| p.id} & @cart_prizes.map{|p| p.prize_id }).empty?
      @pack_prizes = []
    end
    # @pack_prizes = @active_event.prizes.pack.where(amount: @top_pack_prize.amount).where.not(id: @cart_prizes.map{|p|p.prize_id})
    @bsa_prizes = @active_event.prizes.bsa.order(:amount) if @active_event
    @total_bsa_prize_amounts = current_scout.total_bsa_prize_amounts(@active_event)
    @eligible_bsa_prizes = @active_event.prizes.bsa.order(:amount).where("amount < ?", @total_sales - @total_bsa_prize_amounts)
    @bsa_bonus_prizes = @active_event.prizes.bsa_bonus.where("amount < ?", @total_sales).order(amount: :desc)
  end

  def selection
    @prize = Prize.find(params[:id])
    scout_prize = current_scout.scout_prizes.build(prize_id: @prize.id, prize_amount: @prize.amount, event_id: @active_event.id)
    if scout_prize.save
      redirect_to prize_cart_path
    else
      redirect_to prize_cart_path, notice: 'There was an error'
    end
  end

  def removal
    current_scout.scout_prizes.find(params[:id]).destroy
    redirect_to prize_cart_path
  end

  # GET /prizes/new
  def new
    @prize = Prize.new
  end

  # GET /prizes/1/edit
  def edit
  end

  # POST /prizes
  # POST /prizes.json
  def create
    @prize = @unit.prizes.new(prize_params)

    respond_to do |format|
      if @prize.save
        format.html { redirect_to @prize, notice: 'Prize was successfully created.' }
        format.json { render :show, status: :created, location: @prize }
      else
        format.html { render :new }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prizes/1
  # PATCH/PUT /prizes/1.json
  def update
    respond_to do |format|
      if @prize.update(prize_params)
        format.html { redirect_to @prize, notice: 'Prize was successfully updated.' }
        format.json { render :show, status: :ok, location: @prize }
      else
        format.html { render :edit }
        format.json { render json: @prize.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prizes/1
  # DELETE /prizes/1.json
  def destroy
    @prize.destroy
    respond_to do |format|
      format.html { redirect_to prizes_url, notice: 'Prize was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prize
      @prize = Prize.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prize_params
      params.require(:prize).permit(:name, :amount, :event_id, :source, :source_id, :source_description, :is_by_level, :url, :description, :group, :cost)
    end
end
