# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
	belongs_to :user

	def student?
		name == 'Student'
	end

	def teacher?
		name == 'Profesor'
	end

	def self.create_roles
		create(name: "Student")
		create(name: "Profesor")
	end
end
