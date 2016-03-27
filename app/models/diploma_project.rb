# == Schema Information
#
# Table name: diploma_projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  students   :integer
#  duration   :integer
#  created_at :datetime
#  updated_at :datetime
#

class DiplomaProject < ActiveRecord::Base
	belongs_to :student
	belongs_to :teacher
end
