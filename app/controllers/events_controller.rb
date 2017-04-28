class EventsController < ApplicationController

  def index
    @events = @unit.events.where(unit_id: @unit.id).order(is_active: :desc)
  end

  def show
    @event = Event.find(params[:id])
    cookies[:event_id] = @event.id
    current_scout.update(event_id: @event.id)
    redirect_to events_path
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def edit_commission_percentage
    @event = @active_event
  end

  def create
    @event = @unit.events.build(event_params)
    if @event.save
      current_scout.update(event_id: @event.id)
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      frender :new
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  def archive
    @event = Event.find(params[:event_id])
    if params[:unarchive]
      @event.update(is_active: true)
    else
      @event.update(is_active: false)
    end
    redirect_to events_path
  end

  private
    def event_params
      params.require(:event).permit(:unit_id, :name, :is_active, :unit_commission_percentage, :prize_cart_ordering_starts_at, :prize_cart_ordering_ends_at, :number_of_top_sellers, :take_orders_deadline_at, :online_commission_percentage, :is_prizes_enabled, :is_online_enabled, :is_take_orders_enabled, :is_site_sales_enabled, :show_top_sellers, :admin_email)
    end
end
