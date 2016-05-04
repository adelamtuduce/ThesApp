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

	def personal_information
		user.personal_information
	end
end
