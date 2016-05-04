# == Schema Information
#
# Table name: diploma_projects
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  max_students :integer
#  duration     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  teacher_id   :integer
#  description  :text
#

class DiplomaProject < ActiveRecord::Base
	has_many :students
	belongs_to :teacher

	def displayed_data
		{
			id: id,
			name: name,
			students: max_students,
			duration: duration,
			description: description,
			actions: "<span class='deleteProject' id=#{id} style='cursor: pointer;'><i class='fa fa-times' aria-hidden='true'></i></span>"
		}
	end

	def student_displayed_data
		{
			name: name,
			students: max_students - students.count,
			duration: duration,
			description: description,
			teacher: teacher.name,
			actions: "<span class='enrollProject' data-project-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Request enroll' class='fa fa-envelope' aria-hidden='true'></i></i></span>
					  <span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"
		}
	end
end


