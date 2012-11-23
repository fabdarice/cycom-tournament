class EventsController < ApplicationController
  respond_to :html
  
  before_filter :check_admin, :except => [ :index, :show ]

  def index
    @events = Event.order("ends_at DESC")

    respond_with(@events)
  end

  def show
    @event = Event.find(params[:id])

    respond_with(@event)
  end

  def new
    @event = Event.new

    respond_with(@event)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.create(params[:event])

    respond_with(@event)
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    
    respond_with(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_with(:location => events_path)
  end
end
