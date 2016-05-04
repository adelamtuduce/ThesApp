class DiplomaProjectsController < ApplicationController
	before_filter :authenticate_user!

	def new
	end

	def create
		@diploma_project = DiplomaProject.new(diploma_project_params)
		if @diploma_project.save
			render json: { status: 'success', message: 'Diploma project successfully added!'}
		else
			render json: {status: 'error', message: 'Errooooooor'}
		end 
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