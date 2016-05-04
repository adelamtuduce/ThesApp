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
#  teacher_id :integer
#

class DiplomaProject < ActiveRecord::Base
	belongs_to :student
	belongs_to :teacher

	def displayed_data
		{
			id: id,
			name: name,
			students: students,
			duration: duration,
			description: description,
			actions: "<span class='deleteProject' id=#{id} style='cursor: pointer;'><i class='fa fa-times' aria-hidden='true'></i></span>"
		}
	end
end


