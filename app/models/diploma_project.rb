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

	def available_diploma?(student)
		return false if max_students == students.count
		return false if EnrollRequest.where(student: student, diploma_project: self).any?
		true
	end

	def student_displayed_data(student)
		if available_diploma?(student)
			html = "<span class='enrollProject' data-teacher-id=#{teacher.id} data-project-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' class='fa fa-plus' title='Apply to project' style='color:green;' aria-hidden='true'></i></i></span>
					  <span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"
		else
			html = "<span><i class='fa fa-star' data-toggle='tooltip' data-placement='top' title='You can not enroll to this project anymore!' style='color:blue;' aria-hidden='true'></i></span> <span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"

		end
		{
			name: name,
			students: max_students - students.count,
			duration: duration,
			description: description,
			teacher: teacher.name,
			actions: html
		}
	end
end


