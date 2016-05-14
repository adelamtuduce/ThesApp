# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Teacher < ActiveRecord::Base
	has_many :diploma_projects
	belongs_to :user
	has_many :enroll_requests

	  scope :in_interval, -> (start_date, end_date) { where("date(created_at) >= date('#{start_date}') AND date(created_at) <= date('#{end_date}')") }

	def name
		first_name = user.personal_information.first_name.blank? ? '' : user.personal_information.first_name
		last_name = user.personal_information.last_name.blank? ? '' : user.personal_information.last_name

		first_name + ' ' + last_name
	end

	def uploaded_documents
		user.documents
	end

	def self.retrieve_all_teachers(params)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = all.count
		response[:recordsFiltered] = all.count
		response[:data] = all.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		response
	end

	def own_projects(params)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = diploma_projects.count
		response[:recordsFiltered] = diploma_projects.count
		response[:data] = diploma_projects.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		response
	end

	def pending_enrollments(params)
		response = {}
		enrollments = enroll_requests.where(accepted: nil, sent: true)
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = enrollments.count
		response[:recordsFiltered] = enrollments.count
		response[:data] = enrollments.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		response
	end

	def accepted_enrollments(params)
		accepted_enrollments = enrollments = enroll_requests.where(accepted: true)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = accepted_enrollments.count
		response[:recordsFiltered] = accepted_enrollments.count
		response[:data] = accepted_enrollments.offset(params[:start].to_i).limit(params[:length].to_i).map(&:accepted_displayed_data)
		response
	end

	def students
		Student.where(diploma_project_id: diploma_projects.map(&:id))
	end

	def displayed_data
		{
			name: name,
			diploma_project: diploma_projects.count,
			actions: ''
		}
	end
end
