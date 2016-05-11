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

  before_action :set_teacher, only: [:show_students, :show_projects, :accepted_requests, :show_enrollments, :retrieve_projects, :enrollment_requests]

	def show_students
		@students = @teacher.students
	end

	def show_projects
	end

	def show_enrollments
	end

	def retrieve_projects
		@projects = @teacher.diploma_projects
		@project_data = @projects.map(&:displayed_data)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = @projects.count
		response[:recordsFiltered] = @projects.count
		response[:data] = @projects.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		render json: response
	end

	def enrollment_requests
		@enrollments = EnrollRequest.where(teacher: @teacher, accepted: nil).uniq
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = @enrollments.count
		response[:recordsFiltered] = @enrollments.count
		response[:data] = @enrollments.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		render json: response
	end

	def accepted_requests
		@accepted_enrollments = EnrollRequest.where(teacher: @teacher, accepted: true).uniq
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = @accepted_enrollments.count
		response[:recordsFiltered] = @accepted_enrollments.count
		response[:data] = @accepted_enrollments.offset(params[:start].to_i).limit(params[:length].to_i).map(&:accepted_displayed_data)
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

	def set_teacher
		@teacher = Teacher.find_by(user_id: current_user.id)
	end
end
