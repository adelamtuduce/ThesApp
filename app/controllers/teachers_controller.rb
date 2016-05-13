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

  before_action :set_teacher, only: [:own_dashboard, :show_students, :show_projects, :accepted_requests, :show_enrollments, :retrieve_projects, :enrollment_requests]

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
										.first.start_at.strftime("%Y-%m-%d %T")
		@notifications = Notification.where(user_id: @teacher.user.id, read: false)
		@enrolls = EnrollRequest.where(teacher: @teacher, accepted: true).count
		@pending_enrolls = EnrollRequest.where(teacher: @teacher, accepted: nil).count
		@proposed_projects = DiplomaProject.where(teacher_id: @teacher).count
	end

	def set_teacher
		@teacher = Teacher.find_by(user_id: current_user.id)
	end
end
