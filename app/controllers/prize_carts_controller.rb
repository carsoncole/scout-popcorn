class PrizeCartsController < ApplicationController
  before_action :redirect_unless_admin!, except: [:show, :order_prizes, :selection, :removal]

  def index
    redirect_to root_path unless current_scout.admin?
    @prize_carts = @active_event.prize_carts.includes(:scout).order("scouts.last_name ASC")
    if params[:ordered]
      @prize_carts = @prize_carts.ordered_and_not_approved
    elsif params[:approved]
      @prize_carts = @prize_carts.approved
    else
      @prize_carts = @prize_carts.open
    end

    @approved_prizes = @active_event.prize_carts.approved.joins(cart_prizes: :prize).order("prizes.source, prizes.amount").group('cart_prizes.prize_id').count('cart_prizes.prize_id')
    @ordered_prizes = @active_event.prize_carts.ordered.joins(cart_prizes: :prize).order("prizes.source, prizes.amount").group('cart_prizes.prize_id').count('cart_prizes.prize_id')
  end

  def show
    @prize_cart = current_scout.prize_cart(@active_event)
    #Prize.process_bonus_prizes!(@active_event, current_scout) unless current_scout.admin? || params[:recalc]
    @total_sales = current_scout.total_sales(@active_event)
    @cart_prizes = @prize_cart.cart_prizes.order(:prize_amount)
    @available_pack_prizes = @active_event.prizes.pack.where("amount <= ?", @total_sales).order(amount: :desc)
    @pack_prizes = @active_event.prizes.pack.where("amount <= ?", @total_sales).select("MAX(amount), *").group(:group)
    unless (@active_event.prizes.pack.map{|p| p.id} & @cart_prizes.map{|p| p.prize_id }).empty?
      @pack_prizes = []
    end
    @bsa_prizes = @active_event.prizes.bsa.order(:amount) if @active_event
    @bsa_prize_amounts_selected = current_scout.prize_cart(@active_event).cart_prizes.joins(:prize).where("prizes.source = ?", 'bsa').sum(:prize_amount)
    @total_bsa_prize_amounts = current_scout.total_bsa_prize_amounts(@active_event)
    @eligible_bsa_prizes = @active_event.prizes.bsa.order(:amount).where("amount < ?", @total_sales - @total_bsa_prize_amounts)
    @bsa_bonus_prizes = @active_event.prizes.bsa_bonus.where("amount < ?", @total_sales).order(amount: :desc)
  end

  def destroy
    @prize_cart = PrizeCart.find(params[:id])
    @prize_cart.destroy
    redirect_to prize_carts_path
  end

  def order_prizes
    @prize_cart = PrizeCart.find(params[:id])
    if @prize_cart.orderable?
      @prize_cart.update(is_ordered_at: Time.now)
      PrizeCartMailer.receipt(@prize_cart).deliver_now
      redirect_to prize_cart_path, notice: 'Successfully ordered prizes.'
    else
      redirect_to prize_cart_path, alert: 'There was a problem with your order. Your cart should not have more BSA prizes than the amount of scout sales.'
    end
  end

  def unorder
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_ordered_at: nil)
    redirect_to prize_carts_path, notice: "Prize card was unordered."
  end

  def approve
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_approved_at: Time.now)
    redirect_to prize_carts_path, notice: "Prize was approved."
  end

  def unapprove
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_approved_at: nil)
    redirect_to prize_carts_path, notice: "Prize was unapproved."
  end

  def selection
    @prize = Prize.find(params[:id])
    cart_prize = current_scout.prize_cart(@active_event).cart_prizes.build(prize_id: @prize.id, prize_amount: @prize.amount)
    if cart_prize.save
      redirect_to prize_cart_path(recalc: false)
    else
      redirect_to prize_cart_path, notice: cart_prize.errors.full_messages
    end
  end  

  def removal
    current_scout.prize_cart(@active_event).cart_prizes.find(params[:id]).destroy
    redirect_to prize_cart_path(recalc: false)
  end
end
