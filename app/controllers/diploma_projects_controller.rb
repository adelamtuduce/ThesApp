# == Schema Information
#
# Table name: diploma_projects
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  max_students :integer
#  duration     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  teacher_id   :integer
#  description  :text
#

class DiplomaProjectsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@diploma_projects = DiplomaProject.all
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = @diploma_projects.count
		response[:recordsFiltered] = @diploma_projects.count
		response[:data] = @diploma_projects.offset(params[:start].to_i).limit(params[:length].to_i).map(&:student_displayed_data)
		render json: response
	end

	def new
	end

	def create
		@diploma_project = DiplomaProject.new(diploma_project_params)
		if @diploma_project.save
			respond_to do |format|
  			format.js
			end
		end 
	end

	def destroy
		@diploma_project = DiplomaProject.find(params[:id])
		@diploma_project.destroy
		render nothing: true
	end

	private

	def diploma_project_params
		params.require(:diploma_project).permit(
    	:name, 
    	:students, 
    	:duration,
    	:description,
    	:teacher_id)
	end

end
