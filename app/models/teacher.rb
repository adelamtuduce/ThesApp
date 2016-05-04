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

	def name
		first_name = user.personal_information.first_name.blank? ? '' : user.personal_information.first_name
		last_name = user.personal_information.last_name.blank? ? '' : user.personal_information.last_name

		first_name + '' + last_name
	end

	def students
		Student.where(diploma_project_id: diploma_projects.map(&:id))
	end
end
