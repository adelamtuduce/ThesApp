class TeachersController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_teacher, only: [:show_students, :show_projects]

	def show_students
		@students = @teacher.students
	end

	def show_projects
		@projects = @teacher.diploma_projects
	end

	def set_teacher
		@teacher = Teacher.find_by(user_id: current_user.id)
	end
end
