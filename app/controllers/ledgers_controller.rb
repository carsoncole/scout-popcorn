class LedgersController < ApplicationController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]

  # GET /ledgers
  # GET /ledgers.json
  def index
    @ledgers = @unit.ledgers.order(date: :desc, created_at: :desc).page(params[:page]).per(50)
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
    @accounts = @unit.accounts.is_bank_account_depositable
    @deposit = true
    render :new
  end

  # GET /ledgers/1/edit
  def edit
  end

  # POST /ledgers
  # POST /ledgers.json
  def create
    @ledger = Ledger.new(ledger_params)

    if @ledger.is_bank_deposit
      @contra_ledger = Ledger.new(ledger_params)
      @contra_ledger.account_id = ledger_params[:from_account_id]
      @contra_ledger.amount = -ledger_params[:amount].to_f
    end
    respond_to do |format|
      if @ledger.save && @contra_ledger.save
        format.html { redirect_to ledgers_path, notice: 'Ledger was successfully created.' }
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
      params.require(:ledger).permit(:account_id, :description, :amount, :date, :is_bank_deposit, :from_account_id)
    end
end
