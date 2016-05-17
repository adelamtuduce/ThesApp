# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class TeachersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_teacher, only: [:retrieve_charts_data, :own_dashboard, :show_students, :show_projects, :accepted_requests, :show_enrollments, :retrieve_projects, :enrollment_requests]
  before_action :copy_to_local_import, only: [:start_import_parser]

  protect_from_forgery :except => [:import_projects]

	def show_students
		@students = @teacher.students
	end

	def show_projects
	end

	def show_enrollments
	end

	def retrieve_all_teachers
		response = Teacher.retrieve_all_teachers(params)
		render json: response
	end

	def retrieve_projects
		response = @teacher.own_projects(params)
		render json: response
	end

	def enrollment_requests
		response = @teacher.pending_enrollments(params)
		render json: response
	end

	def accepted_requests
		response = @teacher.accepted_enrollments(params)
		render json: response
	end

	def accept_student_enrollment
		student = Student.find(params[:student_id])
		diploma_project = DiplomaProject.find(params[:project_id])
		teacher = diploma_project.teacher
		student.diploma_project = diploma_project
		student.save
		enroll_request = EnrollRequest.find_by(student: student, teacher: teacher, diploma_project: diploma_project)
		EnrollRequest.where.not(id: enroll_request.id).where(student: student).destroy_all if student.diploma_project
		enroll_request.update_attributes(accepted: true)
		# AcceptEnrollmentMailer.accept_request
		render json: { success: true }
	end

	def decline_student_enrollment
		student = Student.find_by(params[:student_id])
		diploma_project = DiplomaProject.find_by(params[:project_id])
		enroll_request = EnrollRequest.find_by(student: student, teacher: diploma_project.teacher, diploma_project: diploma_project)
		enroll_request.accepted = false
		enroll_request.save
	end

	def retrieve_own_students
		requests = EnrollRequest.where(teacher_id: params['id'])
		@response = []

		requests.each do |request|
			@response << {id: request.student.id, name: request.student.name}
		end
	end

	def retrieve_own_events
		events = Event.all.where(teacher_id: params['id'])

   render :json => events.map {|event| {
              :id => event.id,
              :start_date => event.start_at.strftime("%Y-%m-%d %T"),
              :end_date => event.end_at.strftime("%Y-%m-%d %T"),
              :text => event.title + ' - ' + 'Student: ' + event.student.name,
          }}
	end

	def own_dashboard
		@next_meeting = Event.where(teacher: @teacher)
										.where("start_at >= ?", Time.now.strftime("%Y-%m-%d %T"))
		if @next_meeting.any?
			@meeting_date = @next_meeting.first.start_at.strftime("%Y-%m-%d %T") 
		else
			@meeting_date = 'No new meetings yet.'
		end

		@notifications = Notification.where(user_id: @teacher.user.id, read: false)
		@enrolls = EnrollRequest.where(teacher: @teacher, accepted: true).count
		@pending_enrolls = EnrollRequest.where(teacher: @teacher, accepted: nil).count
		@proposed_projects = DiplomaProject.where(teacher_id: @teacher).count
	end

	def show_import_modal
		@teacher = Teacher.find(params[:id])

		respond_to do |format|
      format.html { render partial: 'import_projects_modal', locals: { teacher: @teacher }, layout: false }
    end
	end

	def import_projects 
		@import_file = ImportProject.new(import_params)
		@import_file.status = 'pending'
		@import_file.save
		render nothing: true
	end

	def start_import_parser
		status = ''
		message = ''
		if @temporary_file
			if CSV.readlines(@temporary_file)[0].compact.blank?
				status = 'error'
				message = 'Improper file'
			end
			status, message = Resque.enqueue(ProjectsParserWorker, @last_import)
		else
			status = 'error'
			message = 'Wrong'
		end

	end

	def retrieve_charts_data
		@requests = EnrollRequest.where(teacher_id: @teacher.id)

		start_valid = true
    end_valid   = true

    begin
      from = Date.parse(Date.strptime(params[:chart_from], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_from] && params[:chart_from].length == 10
    rescue ArgumentError
      start_valid = false
    end
    begin
      to = Date.parse(Date.strptime(params[:chart_to], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_to] && params[:chart_to].length == 10
    rescue ArgumentError
      end_valid = false
    end

    to   = Time.zone.now.to_date if to.nil? || !end_valid
    from = to - 6.days if from.nil? || !start_valid

    from = to if from > to
    result = []
    from.to_date.step(to.to_date) do |day|
    	start = day.beginning_of_day.strftime("%Y-%m-%d %T")
    	end_day = day.end_of_day.strftime("%Y-%m-%d %T")
    	requests_list = @requests.in_interval(start, end_day)
    	value = {
    		x: day.to_date.strftime("%Y-%m-%d"),
    		wishlist: requests_list.where(sent: false).count,
    		requests: requests_list.where(sent: true).count,
    		total: requests_list.count
    	}
    	ap value
    	result << value
    end
    render json: { result: result }
	end

	private 

	def set_teacher
		@teacher = Teacher.find_by(user_id: current_user.id)
	end

	def import_params
    params.require(:import_project).permit(
      :import,
      :teacher_id)
	end

	def copy_to_local_import
		@last_import = ImportProject.last 
		return unless import
		@temporary_file = "tmp/import_project_#{last_import.id}.csv"
		@last_import.copy_to_local_file(:original, @temporary_file)
	end
end
