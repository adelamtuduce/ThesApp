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
	has_many :documents

	def displayed_data
		{
			student: student.name,
			project: diploma_project.name,
			actions: "<span class='acceptRequest' data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><i style='color:green;' data-toggle='tooltip' data-placement='top' title='Accept Request' class='fa fa-check' aria-hidden='true'></i></span> 
								<span class='declineRequest' data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><i style='color:red;' data-toggle='tooltip' data-placement='top' title='Decline Request' class='fa fa-times' aria-hidden='true'></i></span>"
		}
	end

	def accepted_displayed_data
		{
			student: student.name,
			project: diploma_project.name,
			actions: "<span class='overviewPage' data-enroll-request=#{id} data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><a href=#{Rails.application.routes.url_helpers.overview_enroll_request_path(id)}><i style='color:green;' data-toggle='tooltip' data-placement='top' title='Go to Overview Page' class='fa fa-globe' aria-hidden='true'></i></a></span> 
								<span class='chatButton' data-enroll-request=#{id} data-student-id=#{student.id} data-diploma-id=#{diploma_project.id} style='cursor: pointer;'><i data-sid=#{teacher.user.id} data-rip=#{student.user.id}  style='color:black;' data-toggle='tooltip' data-placement='top' title='Start conversation'  class='fa fa-weixin start-conversation' aria-hidden='true'></i></span>"
		}
	end


	def diploma_enrolls
		{
			name: diploma_project.name, 
			teacher: teacher.name,
			actions: "<span class='cancelRequest' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Cancel request' style='color:red;' class='fa fa-times' aria-hidden='true'></i></i></span>"
		}
	end
end
