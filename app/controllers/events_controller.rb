class EventsController < ApplicationController

  # GET /events
  # GET /events.json
  def index
    @events = @unit.events.where(unit_id: @unit.id).order(is_active: :desc)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    cookies[:event_id] = @event.id
    current_scout.update(default_event_id: @event.id)
    redirect_to events_path
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = @unit.events.build(event_params)

    respond_to do |format|
      if @event.save
        current_scout.update(default_event_id: @event.id)
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def event_params
      params.require(:event).permit(:unit_id, :name, :is_active, :pack_commission_percentage, :allow_prize_cart_ordering_at, :number_of_top_sellers, :take_orders_deadline_at)
    end
end
