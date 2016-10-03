class LedgersController < ApplicationController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]

  # GET /ledgers
  # GET /ledgers.json
  def index
    @ledgers = @unit.ledgers.order(date: :desc, created_at: :desc).page(params[:page]).per(50)
    if params[:account_id]
      @ledgers = @ledgers.where(account_id: params[:account_id])
    end
    @bank_accounts = @unit.accounts.is_bank_account_depositable
  end

  # GET /ledgers/1
  # GET /ledgers/1.json
  def show
  end

  # GET /ledgers/new
  def new
    @ledger = Ledger.new
    @accounts = @unit.accounts.order(:name)
  end

  def bank_deposit
    @ledger = Ledger.new
    @ledger.is_bank_deposit = true
    @bank_accounts = @unit.accounts.is_bank_account_depositable.order(:name)
    @asset_accounts = @unit.accounts.assets.order(:name)
    @deposit = true
    render :new
  end

  def balance_sheet
    @take_order_cash = @unit.accounts.where(name: 'Take Order Cash').first.balance
    @site_sale_cash = @unit.accounts.where(name: 'Site Sale Cash').first.balance
    @square_cash = @unit.accounts.where(name: 'Square').first.balance
    @bsa_credit_card_cash = @unit.accounts.where(name: 'BSA Credit Card').first.balance if @unit.accounts.where(name: 'BSA Credit Card').first
    @union_bank_cash = @unit.accounts.where(name: 'Union Bank').first.balance if @unit.accounts.where(name: 'Union Bank').first
    @popcorn_inventory = Stock.wholesale_value(@unit, @active_event)
    @due_from_customers = (@unit.accounts.where(name: 'Money due from Customer').first.balance if @unit.accounts.where(name: 'Money due from Customer').any?) || 0
    @total_assets = @take_order_cash + @site_sale_cash + @square_cash + @bsa_credit_card_cash + @union_bank_cash + @popcorn_inventory + @due_from_customers
    @due_to_bsa = (@unit.accounts.where(name: 'Due to BSA').first.balance if @unit.accounts.where(name: 'Due to BSA').any?) || 0#Stock.wholesale_value_due_to_bsa(@unit)
    @product_due_to_customers = (@unit.accounts.where(name: 'Product due to Customers').first.balance if @unit.accounts.where(name: 'Product due to Customers').first) || 0
    @pack_prizes = @active_event.scout_prizes.joins(:prize).where('prizes.source = "pack"').sum('prizes.cost')
    @total_liabilities = @due_to_bsa + @product_due_to_customers
    @total_equity = @total_assets - @total_liabilities
  end

  def income_statement
    @site_sales = @active_event.total_site_sales
    @take_orders = @active_event.total_take_orders
    @online_sales = @active_event.total_online_sales
    @total_sales = @active_event.total_sales
    @total_cost_of_goods_sold = @active_event.cost_of_goods_sold
    @total_expenses = @active_event.cost_of_goods_sold
  end

  # GET /ledgers/1/edit
  def edit
    @accounts = @unit.accounts.order(:name)
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
    respond_to do |format|
      if @ledger.save
        format.html { redirect_to ledgers_path, notice: 'Ledger entry was successfully created.' }
        format.json { render :show, status: :created, location: @ledger }
      else
        format.html { render :new }
        format.json { render json: @ledger.errors, status: :unprocessable_entity }
      end
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
      params.require(:ledger).permit(:account_id, :description, :amount, :date, :is_bank_deposit, :from_account_id, :created_by)
    end
end
