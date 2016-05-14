# == Schema Information
#
# Table name: enroll_requests
#
#  id                 :integer          not null, primary key
#  student_id         :integer
#  teacher_id         :integer
#  diploma_project_id :integer
#  accepted           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  priority           :integer
#  sent               :boolean          default(FALSE)
#

class EnrollRequest < ActiveRecord::Base
	belongs_to :student
	belongs_to :teacher
	belongs_to :diploma_project
	has_many :documents

	scope :in_interval, -> (start_date, end_date) { where("date(enroll_requests.created_at) >= date('#{start_date}') AND date(enroll_requests.created_at) <= date('#{end_date}')") }

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
		if sent 
			html = "<span class='cancelRequest' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Cancel request' style='color:red;' class='fa fa-times' aria-hidden='true'></i></i></span>
					<span class='enrolledProject' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id}><i data-toggle='tooltip' data-placement='top' title='Enroll Request sent'  class='fa fa-envelope-o' aria-hidden='true'></i></i></span>"
		else
			html = "<span class='cancelRequest' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Cancel request' style='color:red;' class='fa fa-times' aria-hidden='true'></i></i></span>
					<span class='enrollProject' data-enroll-id=#{id} data-teacher-id=#{teacher.id} data-project-id=#{diploma_project.id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='Send enroll request' style='color:blue;' class='fa fa-envelope' aria-hidden='true'></i></i></span>"
		end
		{
			name: diploma_project.name, 
			teacher: teacher.name,
			actions: html
		}
	end
end
