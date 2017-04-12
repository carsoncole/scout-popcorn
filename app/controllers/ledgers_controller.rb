class LedgersController < ApplicationController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]

  # GET /ledgers
  # GET /ledgers.json
  def index
    @ledgers = Ledger.joins(account: :event).where("events.id = ?", @active_event).order(date: :desc, created_at: :desc).page(params[:page]).per(50)
    if params[:account_id]
      @ledgers = @ledgers.where(account_id: params[:account_id])
    end
    @bank_accounts = @active_event.accounts.is_bank_account_depositable
  end

  # GET /ledgers/1
  # GET /ledgers/1.json
  def show
  end

  # GET /ledgers/new
  def new
    @ledger = Ledger.new
    @accounts = @active_event.accounts.order(:name)
    @take_order_ids = @active_event.take_orders.joins(:account).where("accounts.name = 'Money due from Customer'").map{|to|["Take Order: #{to.id} - #{to.customer_name}",to.id]}
  end

  def bank_deposit
    @ledger = Ledger.new
    @ledger.is_bank_deposit = true
    @bank_accounts = @active_event.accounts.is_bank_account_depositable.order(:name)
    @asset_accounts = @active_event.accounts.assets.order(:name)
    @deposit = true
    render :new
  end

  def final_unit_settlement_form
    @due_to_bsa_ledgers = Ledger.joins(account: :event).where("event_id = ? AND accounts.name = 'Due to BSA'", @active_event.id)#(@active_event.accounts.where(name: 'Due to BSA').first.balance if @active_event.accounts.where(name: 'Due to BSA').any?) || 0
    @due_to_bsa= (@active_event.accounts.where(name: 'Due to BSA').first.balance if @active_event.accounts.where(name: 'Due to BSA').any?) || 0
    @bsa_credit_card_cash = @active_event.accounts.where(name: 'BSA Credit Card').first.balance if @active_event.accounts.where(name: 'BSA Credit Card').any?
    @bsa_online_credits = @active_event.total_online_sales * (@active_event.online_commission_percentage/100)
  end

  def balance_sheet
    @take_order_cash = @active_event.accounts.where(name: 'Take Order Cash').first.balance if @active_event.accounts.where(name: 'Take Order Cash').first
    @site_sale_cash = @active_event.accounts.where(name: 'Site Sale Cash').first.balance if @active_event.accounts.where(name: 'Site Sale Cash').first
    @square_cash = @active_event.accounts.where(name: 'Square').first.balance if @active_event.accounts.where(name: 'Square').first
    @bsa_credit_card_cash = @active_event.accounts.where(name: 'BSA Credit Card').first.balance if @active_event.accounts.where(name: 'BSA Credit Card').first
    @bsa_site_sales_credit_card_cash = @active_event.accounts.where(name: 'BSA Credit Card').first.balance(site_sales: true) if @active_event.accounts.where(name: 'BSA Credit Card').first
    @bsa_take_orders_credit_card_cash = @active_event.accounts.where(name: 'BSA Credit Card').first.balance(take_orders: true) if @active_event.accounts.where(name: 'BSA Credit Card').first
    @union_bank_cash = @active_event.accounts.where(name: 'Union Bank').first.balance if @active_event.accounts.where(name: 'Union Bank').first
    @popcorn_inventory = Stock.wholesale_value(@unit, @active_event)
    @due_from_customers = (@active_event.accounts.where(name: 'Money due from Customer').first.balance if @active_event.accounts.where(name: 'Money due from Customer').any?) || 0
    @bsa_online_credits = @active_event.total_online_sales * (@active_event.online_commission_percentage/100)
    @other_expenses = @active_event.accounts.joins(:ledgers).where("accounts.account_type = 'Expense'").sum("ledgers.amount")

    @total_assets = (@take_order_cash || 0) + (@site_sale_cash||0) + (@square_cash||0) + (@bsa_credit_card_cash||0) + (@union_bank_cash||0) + (@popcorn_inventory||0) + (@due_from_customers||0) + (@bsa_online_credits||0)
    @due_to_bsa = (@active_event.accounts.where(name: 'Due to BSA').first.balance if @active_event.accounts.where(name: 'Due to BSA').any?) || 0
    @product_due_to_customers = (@active_event.accounts.where(name: 'Product due to Customers').first.balance if @active_event.accounts.where(name: 'Product due to Customers').first) || 0
    @pack_prizes = @active_event.prize_carts.ordered_or_approved.joins(cart_prizes: :prize).where('prizes.source = "pack"').sum('prizes.cost')
    @total_liabilities = @due_to_bsa + @product_due_to_customers + @pack_prizes
    @total_equity = @total_assets - @total_liabilities
  end

  def income_statement
    @site_sale_donations = @active_event.total_site_sale_donations
    @site_sales = @active_event.total_site_sales - @site_sale_donations
    @take_order_donations = @active_event.total_take_order_donations
    @take_orders = @active_event.total_take_orders - @take_order_donations
    @online_sales = @active_event.total_online_sales
    @total_sales = @active_event.total_sales
    @total_cost_of_goods_sold = @active_event.cost_of_goods_sold
    @pack_selected_prizes = @active_event.prize_carts.ordered_or_approved.joins(cart_prizes: :prize).where('prizes.source = "pack"').sum('prizes.cost')
    @other_expenses = @active_event.accounts.joins(:ledgers).where("accounts.account_type = 'Expense'").sum("ledgers.amount")
    @total_expenses = @active_event.cost_of_goods_sold + @pack_selected_prizes + @other_expenses
  end

  # GET /ledgers/1/edit
  def edit
    @accounts = @active_event.accounts.order(:name)
  end

  # POST /ledgers
  # POST /ledgers.json
  def create
    @ledger = Ledger.new(ledger_params)
    @ledger.created_by = current_scout.id

    if @ledger.is_bank_deposit
      from_account = Account.find(ledger_params[:from_account_id])
      if from_account
        @ledger.description = "Bank deposit from #{from_account.name}"
      end
      @contra_ledger = Ledger.new(ledger_params)
      @contra_ledger.description = "Bank deposit to #{@ledger.account.name}"
      @contra_ledger.account_id = ledger_params[:from_account_id]
      @contra_ledger.amount = -ledger_params[:amount].to_f
      @contra_ledger.created_by = current_scout.id
      @contra_ledger.save
    end

    if @ledger.is_money_collected
      @ledger.amount = -@ledger.amount
      @ledger.description = "Money collected from customer"
      @ledger.account_id = Account.money_due_from_customer(@active_event).id
      @contra_ledger = Ledger.new(ledger_params)
      @contra_ledger.created_by = current_scout.id
      @contra_ledger.account_id = Account.take_order(@active_event).id
      @contra_ledger.save
    end

    if @ledger.save
      redirect_to ledgers_path, notice: 'Ledger entry was successfully created.'
    else
      render :new
    end

  end

  # PATCH/PUT /ledgers/1
  # PATCH/PUT /ledgers/1.json
  def update
    respond_to do |format|
      if @ledger.update(ledger_params)
        format.html { redirect_to @ledger, notice: 'Ledger was successfully updated.' }
        format.json { render :show, status: :ok, location: @ledger }
      else
        format.html { render :edit }
        format.json { render json: @ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ledgers/1
  # DELETE /ledgers/1.json
  def destroy
    @ledger.destroy
    respond_to do |format|
      format.html { redirect_to ledgers_url, notice: 'Ledger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ledger_params
      params.require(:ledger).permit(:account_id, :description, :amount, :date, :is_bank_deposit, :from_account_id, :created_by, :is_money_collected, :take_order_id)
    end
end
