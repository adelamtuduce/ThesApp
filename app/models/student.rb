# == Schema Information
#
# Table name: students
#
#  id                 :integer          not null, primary key
#  diploma_project_id :integer
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  teacher_id         :integer
#

class Student < ActiveRecord::Base
	belongs_to :user
	belongs_to :diploma_project
	belongs_to :teacher
	has_many :enroll_requests
	has_many :student_events
	has_many :events, through: :student_events

	scope :in_interval, -> (start_date, end_date) { where("date(created_at) >= date('#{start_date}') AND date(created_at) <= date('#{end_date}')") }

	def personal_information
		user.personal_information
	end

	def uploaded_documents
		user.documents
	end

	def own_enrolls(params)
		enrolls = enroll_requests.order(priority: :asc)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = enrolls.count
		response[:recordsFiltered] = enrolls.count
		response[:data] = enrolls.offset(params[:start].to_i).limit(params[:length].to_i).map(&:diploma_enrolls)
		response
	end

	def self.retrieve_students(params)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = all.count
		response[:recordsFiltered] = all.count
		response[:data] = all.offset(params[:start].to_i).limit(params[:length].to_i).map(&:displayed_data)
		response
	end

	def name
		first_name = personal_information.first_name.blank? ? '' : personal_information.first_name
		last_name = personal_information.last_name.blank? ? '' : personal_information.last_name

		first_name + ' ' + last_name
	end

	def displayed_data
		html = "<span class='deleteUser' data-user-id=#{user.id}><i class='fa fa-minus-circle' data-toggle='tooltip' data-placement='top' title='Delete user' style='color:red;' aria-hidden='true'></i></span>"
		html += "<span class='acceptUser' data-user-id=#{user.id}><i class='fa fa-user-plus' data-toggle='tooltip' data-placement='top' title='Accept registration' style='color:green;' aria-hidden='true'></i></span>" unless user.approved
		{
			name: name.blank? ? user.email : name,
			code: user.personal_information.code,
			actions: html
		}
	end

	def self.students_report(temporary_local_file)
  	file = CSV.open(
      temporary_local_file,
      'w',
      write_headers: true,
      headers: ['Name', 'Diploma Project', 'Email', 'Faculty']
    ) do |csv|
      if any?
        all.each do |student|
		      name = student.name
		      project = student.diploma_project.nil? ? '-' : student.diploma_project.name
		      email = student.user.email
		      faculty = student.user.personal_information.nil? || student.user.personal_information.faculty_name.nil? ? 'Not added yet.' : student.user.personal_information.faculty_name
		      data_out = [ name, project, email, faculty]
		      csv << data_out
		    end
      else
        csv << ['There are no students yet.']
      end
    end
    temporary_local_file
  end
end
