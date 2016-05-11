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

	def name
		first_name = personal_information.first_name.blank? ? '' : personal_information.first_name
		last_name = personal_information.last_name.blank? ? '' : personal_information.last_name

		first_name + ' ' + last_name
	end
end
