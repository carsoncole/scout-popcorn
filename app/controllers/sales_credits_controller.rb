class SalesCreditsController < ApplicationController
  before_action :authorize_prizes_admin
  
  def index
    @sales_credits = @active_event.sales_credits
    @scout_balances = @sales_credits.group(:scout_id).sum(:amount)
  end

  def show
  end

  def edit
  end

  def udpate
  end

  def new
  end

  def create
  end

  def destroy
  end

  def assignment
    @from = Scout.find(params[:from])
    @to = Scout.find(params[:to])
    SalesCredit.transaction do
      from = SalesCredit.new(scout_id: @from.id, event_id: @active_event.id, amount: -@from.sales_credit_balance(@active_event), description: "Assignment of sales credits to #{@to.name}.")
      to = SalesCredit.new(scout_id: @to.id, event_id: @active_event.id, amount: @from.sales_credit_balance(@active_event), description: "Assignment of sales credits from #{@from.name}.")   
      from.save
      to.save   
    end
    redirect_to sales_credits_path, notice: 'Sales credits transferred.'
  end
end
