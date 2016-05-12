class StudentsController < ApplicationController

	before_action :set_student, only: [:student_dasboard]
	 
	def retrieve_all_students
		response = Student.retrieve_students(params)
		render json: response
	end

	def student_dasboard
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