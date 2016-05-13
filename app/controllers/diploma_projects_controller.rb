# == Schema Information
#
# Table name: diploma_projects
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  max_students               :integer
#  duration                   :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  teacher_id                 :integer
#  description                :text
#  documentation_file_name    :string(255)
#  documentation_content_type :string(255)
#  documentation_file_size    :integer
#  documentation_updated_at   :datetime
#

class DiplomaProjectsController < ApplicationController
	before_filter :authenticate_user!


	def index
		response = DiplomaProject.retrieve_all_projects(params, current_user.student)
		render json: response
	end

	def student_enrolls
		student = current_user.student
		response = student.own_enrolls(params)
		render json: response
	end

	def new
	end

	def enroll_student
		diploma_project = DiplomaProject.find(params[:diploma_project_id])
		student = current_user.student
		teacher = diploma_project.teacher
		request = EnrollRequest.where(student: student, teacher: teacher, diploma_project: diploma_project).first_or_create
		request.update_attributes(sent: true)
		# EnrollMailer.enroll_student(student, teacher, diploma_project).deliver
	end

	def update_priorities
		params[:priorities].each do |key, priority_hash|
			puts priority_hash
			priority = priority_hash[:priority]
			request = EnrollRequest.find(priority_hash[:request_id]).update_attributes(priority: priority)
		end

		render nothing: true
	end

	def diploma_project_modal
		@diploma_project = DiplomaProject.find(params[:diploma_project_id])
		respond_to do |format|
      format.html { render partial: 'diploma_project_modal', locals: { diploma_project: @diploma_project }, layout: false }
    end
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

	def upload_documentation
		@project = DiplomaProject.find(params['diploma_project_id'])
		@document = Document.new(document_params)
  	@document.save
  	@document.download_url = @document.file.url
  	@document.save
  	puts @document
	end

	private

	def diploma_project_params
		params.require(:diploma_project).permit(
    	:name, 
    	:max_students, 
    	:duration,
    	:description,
    	:teacher_id,
    	:documentation)
	end

end
