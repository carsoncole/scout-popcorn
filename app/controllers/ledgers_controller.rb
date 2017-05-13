class LedgersController < ApplicationController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]

  def index
    @ledgers = Ledger.joins(account: :event).where("events.id = ?", @active_event).order(date: :desc, created_at: :desc).page(params[:page]).per(50)
    if params[:account_id]
      @ledgers = @ledgers.where(account_id: params[:account_id])
    end
    @bank_accounts = @active_event.accounts.is_bank_account_depositable
  end

  def show
  end

  def new
    @ledger = Ledger.new
    @accounts = @active_event.accounts.order(:name)
    @take_order_ids = @active_event.take_orders.joins(:account).where("accounts.name = 'Money due from Customer'").map{|to|["Take Order: #{to.id} - #{to.customer_name}",to.id]}
  end

  def final_unit_settlement_form
    @due_to_bsa_ledgers = Ledger.joins(account: :event).where("event_id = ? AND accounts.name = 'Due to BSA'", @active_event.id)
    @due_to_bsa= (@active_event.accounts.where(name: 'Due to BSA').first.balance if @active_event.accounts.where(name: 'Due to BSA').any?) || 0
    @bsa_credit_card_cash = @active_event.accounts.where(is_third_party_account: true).first.balance if @active_event.accounts.where(is_third_party_account: true).any?
    @bsa_online_credits = @active_event.total_online_sales * (@active_event.online_commission_percentage/100)
  end

  def balance_sheet
    @popcorn_inventory = Stock.wholesale_value(@active_event)
    @liability_accounts = @active_event.accounts.liabilities.order("accounts.rank")
    @asset_accounts = @active_event.accounts.assets.order("accounts.rank")
  end

  def income_statement
    @site_sale_donations = @active_event.total_site_sale_donations
    @site_sales = @active_event.total_site_sale_sales - @site_sale_donations
    @take_order_donations = @active_event.total_take_order_donations
    @take_orders = @active_event.total_take_order_sales - @take_order_donations
    @online_sales = @active_event.total_online_sales
    @total_sales = @active_event.total_sales
    @total_cost_of_goods_sold = @active_event.cost_of_goods_sold
    @pack_selected_prizes = @active_event.prize_carts.ordered_or_approved.joins(cart_prizes: :prize).where('prizes.source = "pack"').sum('prizes.cost')
    @other_expenses = @active_event.accounts.joins(:ledgers).where("accounts.account_type = 'Expense'").sum("ledgers.amount")
    @total_expenses = @active_event.cost_of_goods_sold + @pack_selected_prizes + @other_expenses
  end

  def edit
    @accounts = @active_event.accounts.order(:name)
  end

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
      @accounts = @active_event.accounts.order(:name)
      render :new
    end

  end

  def update
    if @ledger.update(ledger_params)
      redirect_to @ledger, notice: 'Ledger was successfully updated.'
    else
      @accounts = @active_event.accounts.order(:name)
      render :edit
    end
  end

  def destroy
    @ledger.destroy
    redirect_to ledgers_url, notice: 'Ledger was successfully destroyed.'
  end

  def fund_site_sales
    if request.post?
      @ledger = Ledger.new(ledger_params)
      @ledger.created_by = current_scout.id
      due_to_unit_account = Account.due_to_unit(@active_event)
      site_sale_cash_account = @active_event.accounts.where("name = ?", 'Site Sales cash').first
      @ledger.account = due_to_unit_account
      @ledger.description = 'Money transfer from Unit'
      contra_ledger = Ledger.new(ledger_params)
      contra_ledger.account = site_sale_cash_account
      contra_ledger.description = 'Money transfer from Unit'
      
      double_entry = DoubleEntry.create
      @ledger.double_entry = double_entry
      contra_ledger.double_entry = double_entry

      if @ledger.save && contra_ledger.save
        flash[:notice] = 'Funding of Site Sales was recorded.'
        redirect_to ledgers_path
      else
        @ledger = Ledger.new
        @fund_site_sales = true  
      end
    else
      @ledger = Ledger.new
      @fund_site_sales = true  
    end
  end

  def bank_deposit
    if request.post?
      @ledger = Ledger.new(ledger_params)
      @ledger.created_by = current_scout.id
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

      double_entry = DoubleEntry.create
      @ledger.double_entry = double_entry
      @contra_ledger.double_entry = double_entry

      if @ledger.save && @contra_ledger.save
        flash[:notice] = 'Your bank deposit has been recorded.'
        redirect_to ledgers_path
      else
        @ledger = Ledger.new
        @fund_site_sales = true  
      end
    else
      @ledger = Ledger.new
      @ledger.is_bank_deposit = true
      @bank_accounts = @active_event.accounts.is_bank_account_depositable.order(:name)
      @cash_accounts = @active_event.accounts.cash.order(:name)
      @deposit = true
    end
  end


  private
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end

    def ledger_params
      params.require(:ledger).permit(:account_id, :description, :amount, :date, :is_bank_deposit, :from_account_id, :created_by, :is_money_collected, :take_order_id, :fund_site_sales, :double_entry_id)
    end

end
