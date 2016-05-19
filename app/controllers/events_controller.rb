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
  before_filter :authenticate_user!
  # load_and_authorize_resource

  def index
    if params['enroll_request_id']
      request = EnrollRequest.find(params['enroll_request_id'])
      events = Event.where(student_id: request.diploma_project.students.map(&:id), teacher: request.teacher)
    else
      events = Event.where(student_id: params['student_id'], teacher_id: params['teacher_id'])
    end

   render :json => events.map {|event| {
              :id => event.id,
              :start_date => event.start_at.strftime("%Y-%m-%d %T"),
              :end_date => event.end_at.strftime("%Y-%m-%d %T"),
              :text => event.title
          }}
  end

  def db_action
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_at = params["start_date"]
    end_at = params["end_date"]
    text = params["text"]
    teacher = Teacher.find(params['teacher_id'])
    student = Student.find(params['student_id'])

   case mode
     when "inserted"
       tid = create_event
     when "deleted"
      tid = delete_event
     when "updated"
      tid = update_event
      end
      render :json => {
              :type => mode,
              :sid => id,
              :tid => tid,
          }
    end

  def create_event
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_at = params["start_date"]
    end_at = params["end_date"]
    text = params["text"]
    teacher = Teacher.find(params['teacher_id'])
    student = Student.find(params['student_id'])
    event = Event.create(start_at: start_at, 
                          end_at: end_at, 
                          title: text,
                          student_id: params['student_id'],
                          teacher_id: params['teacher_id'])
    end

     tid = event.id
    if current_user.student?
      Notification.create(user_id: teacher.user.id, 
                          title: "New Appointment - #{student.name}", 
                          message: "A new appointment was added for: #{event.start_at.strftime("%Y-%m-%d %T")} with #{student.name}.")
    end

    if current_user.teacher?
      Notification.create(user_id: student.user.id, 
                          title: "New Appointment - #{teacher.name}", 
                          message: "A new appointment was added for: #{event.start_at.strftime("%Y-%m-%d %T")} with #{teacher.name}.")
    end
    tid
  end

  def delete_event
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_at = params["start_date"]
    end_at = params["end_date"]
    text = params["text"]
    teacher = Teacher.find(params['teacher_id'])
    student = Student.find(params['student_id'])
    event = Event.find(params["id"])
     Event.find(id).destroy
     tid = id

    if current_user.student?
      Notification.create(user_id: teacher.user.id, 
                          title: "Canceled/Declined Apointment - #{student.name}", 
                          message: "The appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} with #{student.name} has been canceled.")
    end

    if current_user.teacher?
      Notification.create(user_id: student.user.id, 
                          title: "Canceled/Declined Apointment - #{teacher.name}", 
                          message: "The appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} has been canceled.")
    end
    tid
  end

  def update_event
    mode = params["!nativeeditor_status"]
    id = params["id"]
    start_at = params["start_date"]
    end_at = params["end_date"]
    text = params["text"]
    teacher = Teacher.find(params['teacher_id'])
    student = Student.find(params['student_id'])
    event =  Event.find(id)
    event_to_update = Event.find(id)
    event_to_update.start_at = start_at
    event_to_update.end_at = end_at
    event_to_update.title = text
    event_to_update.save
    updated_event = Event.find(id)
    tid = id

     if current_user.student?
      if event.title != updated_event.title
        Notification.create(user_id: teacher.user.id, 
                          title: "Updated date of Apointment - #{student.name}", 
                          message: "The The title of the appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} - #{event.end_at.strftime("%Y-%m-%d %T")} was changed from '#{event.title.humanize}' to '#{updated_event.title.humanize}'.")
      end
      if event.start_at != updated_event.start_at || event.end_at != updated_event.end_at
        Notification.create(user_id: teacher.user.id, 
                          title: "Updated date of Apointment - #{student.name}", 
                          message: "The appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} - #{event.end_at.strftime("%Y-%m-%d %T")} with #{student.name} has been moved in the time interval: #{updated_event.start_at.strftime("%Y-%m-%d %T")} - #{updated_event.end_at.strftime("%Y-%m-%d %T")}.")
      end
    end

    if current_user.teacher?
     if event.title != updated_event.title
        Notification.create(user_id: student.user.id, 
                          title: "Updated date of Apointment - #{teacher.name}", 
                          message: "The The title of the appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} - #{event.end_at.strftime("%Y-%m-%d %T")} was changed from '#{event.title.humanize}' to '#{updated_event.title.humanize}'.")
      end
      if event.start_at != updated_event.start_at || event.end_at != updated_event.end_at
        Notification.create(user_id: student.user.id, 
                          title: "Updated date of Apointment - #{teacher.name}", 
                          message: "The appointment scheduled for: #{event.start_at.strftime("%Y-%m-%d %T")} - #{event.end_at.strftime("%Y-%m-%d %T")} with #{teacher.name} has been moved in the time interval: #{updated_event.start_at.strftime("%Y-%m-%d %T")} - #{updated_event.end_at.strftime("%Y-%m-%d %T")}.")
      end
    end
    tid
  end
end
