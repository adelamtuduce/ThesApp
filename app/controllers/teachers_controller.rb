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

  before_action :set_teacher, only: [:show_students, :show_projects, :retrieve_projects]

	def show_students
		@students = @teacher.students
	end

	def show_projects
		
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

	def set_teacher
		@teacher = Teacher.find_by(user_id: current_user.id)
	end
end
