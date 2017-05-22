class PrizesController < ApplicationController
  before_action :set_prize, only: [:show, :edit, :update, :destroy]
  before_action :authorize_prizes_admin, except: :index

  def index
  end

  def show
  end

  def new
    @prize = Prize.new
  end

  def edit
  end

  def create
    @prize = @active_event.prizes.new(prize_params)

    if current_scout.is_prizes_admin && @prize.save
      redirect_to @prize, notice: 'Prize was successfully created.'
    else
      render :new
    end
  end

  def update
    if @prize.update(prize_params)
      redirect_to @prize, notice: 'Prize was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if current_scout.is_prizes_admin?
      @prize.destroy
      redirect_to prizes_url, notice: 'Prize was successfully destroyed.'
    else
      redirect_to prizes_url
    end
  end

  private
    def set_prize
      @prize = Prize.find(params[:id])
    end

    def prize_params
      params.require(:prize).permit(:name, :sales_amount, :event_id, :source, :source_id, :source_description, :is_by_level, :url, :description, :group, :cost)
    end
end
