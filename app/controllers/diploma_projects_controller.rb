class DiplomaProjectsController < ApplicationController
	before_filter :authenticate_user!

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