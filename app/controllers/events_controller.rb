# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  allDay     :string(255)
#  student_id :integer
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class EventsController < ApplicationController
  def new
    @event = Event.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      render json: {msg: 'your event was saved.'}
    else
      render json: {msg: 'error: something go wrong.' }, status: 500
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(start_at: params['start'], end_at: params['end'])
      render json: {message: 'success'}
    else    
      render json: {message: 'error'}
    end
  end

  def index
    puts params
    puts Event.between(params['start'], params['end']) if (params['start'] && params['end']) 
    @events = Event.between(params['start'], params['end']) if (params['start'] && params['end']) 

    respond_to do |format| 
      format.html
      format.json { render :json => @events } 
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event.destroy
  end

  def event_params
    params.permit(:title, :id).merge start_at: params[:start], end_at: params[:end], teacher_id: params[:teacher_id], student_id: params[:student_id]
  end
end
