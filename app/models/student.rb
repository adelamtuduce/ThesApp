# == Schema Information
#
# Table name: students
#
#  id                 :integer          not null, primary key
#  diploma_project_id :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Student < ActiveRecord::Base
	has_one :user
	has_one :diploma_project
end
