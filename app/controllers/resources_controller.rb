class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: :index
  before_action :authorize_unit_admin, except: :index
  # before_action :set_event, only: [:index, :new, :show, :edit, :update, :destroy]

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/new
  def new
    @resource = @active_event.resources.build
  end

  # GET /resources/1/edit
  def edit
  end

  def create
    @resource = @active_event.resources.build(resource_params)

    if @resource.save
      redirect_to resources_url, notice: 'Resource was successfully created.'
    else
      render :new
    end
  end

  def update
    if @resource.update(resource_params)
      redirect_to resources_path, notice: 'Resource was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to resources_url, notice: 'Resource was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # def set_event
    #   @event = Event.find(params[:event_id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
      params.require(:resource).permit(:event_id, :name, :url)
    end
end
