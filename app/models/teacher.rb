# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Teacher < ActiveRecord::Base
	has_many :diploma_projects
	has_one :user
end
