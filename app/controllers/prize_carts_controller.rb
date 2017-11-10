class PrizeCartsController < ApplicationController
  before_action :authorize_prizes_admin, except: [:show, :order, :order_prizes, :unorder, :removal]

  def index
    @prize_carts = @active_event.prize_carts.includes(:scout).where("scouts.is_admin = ?", true).order("scouts.last_name ASC").page(params[:page]).per(40)
  end

  def show
    if current_scout.is_prizes_admin?
      @prize_cart = PrizeCart.find(params[:id])
    else
      @prize_cart = current_scout.prize_cart(@active_event)
    end
    @prize_cart.process_automatic_prizes!
    @cart_prize_sources = @prize_cart.cart_prizes.joins(:prize).pluck('prizes.source').uniq
  end

  def approved_prizes
    @approved_prizes = @active_event.prize_carts.approved.joins(cart_prizes: :prize).order("prizes.source, prizes.sales_amount").group('cart_prizes.prize_id').sum('cart_prizes.quantity')
  end

  def order_prizes
    @prize_cart = PrizeCart.find(params[:id])
    if @prize_cart.orderable?
      @prize_cart.update(is_ordered_at: Time.now)
      # PrizeCartMailer.receipt(@prize_cart).deliver_now
      redirect_to prize_cart_path, notice: 'Successfully ordered prizes.'
    else
      redirect_to prize_cart_path, alert: 'There was a problem with your order. Your cart should not have more BSA prizes than the amount of scout sales.'
    end
  end

  def order
    prize = @active_event.prizes.where(id: params[:prize_id]).first
    prize_cart = current_scout.prize_cart(@active_event)
    if existing_selected_prize = prize_cart.cart_prizes.where(prize: prize).first
      existing_selected_prize.update(quantity: existing_selected_prize.quantity + 1 )
    else
      current_scout.prize_cart(@active_event).cart_prizes.create(prize: prize, prize_amount: prize.reduces_sales_credits? ? prize.sales_amount : nil, quantity: 1)
    end
    redirect_to prizes_path
  end

  def unorder
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_ordered_at: nil)
    redirect_to @cart, notice: "Prize cart has been unordered."
  end

  def approve
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_approved_at: Time.now)
    redirect_to @cart, notice: "Prize cart was approved."
  end

  def unapprove
    @cart = PrizeCart.find(params[:id])
    @cart.update(is_approved_at: nil)
    redirect_to @cart, notice: "Prize cart was unapproved."
  end

  def removal
    c = CartPrize.find(params[:id]).destroy
    redirect_to prize_cart_path(c.prize_cart)
  end
end
