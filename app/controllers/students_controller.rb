# == Schema Information
#
# Table name: students
#
#  id                 :integer          not null, primary key
#  diploma_project_id :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  teacher_id         :integer
#

class StudentsController < ApplicationController
	before_filter :authenticate_user!
  	load_and_authorize_resource
	# before_action :redirect_to_select, only: [:student_dasboard]
	before_action :set_student, only: [:student_dasboard]
	 
	def retrieve_all_students
		response = Student.retrieve_students(params)
		render json: response
	end

	def student_dasboard
		@next_meeting = Event.where(student: @student, teacher: @enrolled_teacher)
										.where("start_at >= ?", Time.now.strftime("%Y-%m-%d %T"))
		if @next_meeting.any?
			@meeting_date = @next_meeting.first.start_at.strftime("%Y-%m-%d %T") 
		else
			@meeting_date = 'No new meetings yet.'
		end										
		@notifications = Notification.where(user_id: @student.user.id, read: false)
	end

	def projects_to_enroll
	end

	private

	def set_student
		@student = current_user.student
		@personal_information = current_user.personal_information
		@diploma_project = @student.diploma_project
		@enrolled_teacher = @diploma_project.teacher
	end
end
