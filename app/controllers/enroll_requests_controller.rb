class EnrollRequestsController < ApplicationController

	before_action :set_request, only: [:destroy]
	def destroy
		@request.destroy
		render nothing: true
	end

	def overview
		@request = EnrollRequest.find(params[:id])
		@diploma_project = @request.diploma_project
		@teacher = @request.teacher
		@student = @request.student
		@documents = @request.documents
		@next_meeting = Event.where(student: @student, teacher: @teacher)
						.where("start_at >= ?", Time.now.strftime("%Y-%m-%d %T"))
						.first.start_at.strftime("%Y-%m-%d %T")

		# redirect_to overview_enroll_request_path(@request)
	end

	private

	def set_request
		@request = EnrollRequest.find(params[:enroll_request_id])
	end
end