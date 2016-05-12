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
    puts params
    @event.update_attributes(start_at: params['start'], end_at: params['end'])
    if @event.update_attributes(start_at: params['start'], end_at: params['end'])
      render json: {message: 'success'}
    else    
      render json: {message: 'error'}
    end
  end

  def db_action
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_at = params["start_date"]
    end_at = params["end_date"]
    text = params["text"]

   case mode
     when "inserted"
       event = Event.create(start_at: start_at, 
                            end_at: end_at, 
                            title: text,
                            student_id: params['student_id'],
                            teacher_id: params['teacher_id'])

       tid = event.id

     when "deleted"
       Event.find(id).destroy
       tid = id

     when "updated"
       event = Event.find(id)
       event.start_at = start_at
       event.end_at = end_at
       event.title = text
       event.save
       tid = id
   end

   render :json => {
              :type => mode,
              :sid => id,
              :tid => tid,
          }
 end

  def index
    events = Event.all.where(student_id: params['student_id'], teacher_id: params['teacher_id'])

   render :json => events.map {|event| {
              :id => event.id,
              :start_date => event.start_at.strftime("%Y-%m-%d %T"),
              :end_date => event.end_at.strftime("%Y-%m-%d %T"),
              :text => event.title
          }}
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event.destroy

    render nothing: true
  end

  def event_params
    params.permit(:title, :id).merge start_at: params[:start], end_at: params[:end], teacher_id: params[:teacher_id], student_id: params[:student_id]
  end
end
