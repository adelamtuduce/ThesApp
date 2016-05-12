# == Schema Information
#
# Table name: students
#
#  id                 :integer          not null, primary key
#  diploma_project_id :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  teacher_id         :integer
#

class Student < ActiveRecord::Base
	belongs_to :user
	belongs_to :diploma_project
	belongs_to :teacher
	has_many :enroll_requests

	def personal_information
		user.personal_information
	end

	def uploaded_documents
		user.documents
	end

	def own_enrolls(params)
		enrolls = enroll_requests.order(priority: :asc)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = enrolls.count
		response[:recordsFiltered] = enrolls.count
		response[:data] = enrolls.offset(params[:start].to_i).limit(params[:length].to_i).map(&:diploma_enrolls)
		response
	end

	def self.retrieve_students(params)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = all.count
		response[:recordsFiltered] = all.count
		response[:data] = all.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		response
	end

	def name
		first_name = personal_information.first_name.blank? ? '' : personal_information.first_name
		last_name = personal_information.last_name.blank? ? '' : personal_information.last_name

		first_name + ' ' + last_name
	end

	def displayed_data
		{
			name: name,
			diploma_project: diploma_project.nil? ? '-' : diploma_project.name,
			actions: ''
		}
	end
end
