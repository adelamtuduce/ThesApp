# == Schema Information
#
# Table name: enroll_requests
#
#  id                 :integer          not null, primary key
#  student_id         :integer
#  teacher_id         :integer
#  diploma_project_id :integer
#  accepted           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  priority           :integer
#  sent               :boolean          default(FALSE)
#

class EnrollRequestsController < ApplicationController
	before_filter :authenticate_user!
  load_and_authorize_resource
	before_action :set_request, only: [:destroy]
	
	def overview
		@request = EnrollRequest.find(params[:id])
		@diploma_project = @request.diploma_project
		@teacher = @request.teacher
		@student = @request.student
		@documents = @request.documents
		@next_meeting = Event.where(teacher_id: @request.teacher.id)
										.where("start_at >= ?", Time.now.strftime("%Y-%m-%d %T"))
		if @next_meeting.any?
			@meeting_date = @next_meeting.first.start_at.strftime("%Y-%m-%d %T") 
		else
			@meeting_date = 'No new meetings yet.'
		end
	end

	def display_tabbed_content
		@request = EnrollRequest.find(params[:id])
		respond_to do |format|
	      format.js
	    end
	end

	def destroy
		@request.destroy
		render nothing: true
	end

	private

	def set_request
		@request = EnrollRequest.find(params[:enroll_request_id])
	end
end
