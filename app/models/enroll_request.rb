# == Schema Information
#
# Table name: enroll_requests
#
#  id                 :integer          not null, primary key
#  student_id         :integer
#  teacher_id         :integer
#  diploma_project_id :integer
#  accepted           :boolean          default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

class EnrollRequest < ActiveRecord::Base
	belongs_to :student
	belongs_to :teacher
	belongs_to :diploma_project

	def displayed_data
		{
			student: student.name,
			project: diploma_project.name,
			actions: "<span class='acceptRequest' data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><i style='color:green;' data-toggle='tooltip' data-placement='top' title='Accept Request' class='fa fa-check' aria-hidden='true'></i></span> 
								<span class='declineRequest' data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><i style='color:red;' data-toggle='tooltip' data-placement='top' title='Decline Request'  class='fa fa-times' aria-hidden='true'></i></span>"
		}
	end


	def diploma_enrolls
		{
			name: diploma_project.name, 
			teacher: teacher.name,
			actions: "<span class='enrollProject' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Cancel request' style='color:red;' class='fa fa-times' aria-hidden='true'></i></i></span>"
		}
	end
end
