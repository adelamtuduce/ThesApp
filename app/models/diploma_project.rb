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
#  time_span    :string(255)
#

class DiplomaProject < ActiveRecord::Base
	has_many :students
	belongs_to :teacher
	has_many :documents

	validates :name, presence: true
	validates :max_students, presence: true
	validates :duration, presence: true
	validates :description, presence: true

	scope :diploma_name, -> (name) { where("name like ?", "#{name}%") }
	scope :diploma_time_span, -> (time_span) { where time_span: time_span }
	scope :diploma_teacher, -> (first_name, last_name) { includes(teacher: { user: :personal_information }).where("personal_informations.first_name like ? AND personal_informations.last_name like ?", "#{first_name}", "#{last_name}") }
  scope :diploma_max_students, -> (max_students) { where max_students: max_students }
  scope :diploma_duration, -> (duration) { where duration: duration }

	scope :in_interval, -> (start_date, end_date) { where("date(created_at) >= date('#{start_date}') AND date(created_at) <= date('#{end_date}')") }


	def get_occupied
		return self if (max_students - students.count) == 0
		nil
	end

	def self.teachers_for_select
		all.map(&:teacher).map(&:name).uniq
	end

	def self.duration_for_select
		all.map(&:duration).uniq
	end

	def self.time_span_for_select
		all.map(&:time_span).uniq
	end

	def self.max_students_for_select
		all.map(&:max_students).uniq
	end

	def self.name_for_select
		all.map(&:name)
	end

	def current_time_span
		time_span.nil? ? '' : time_span
	end

	def displayed_data
		{
			id: id,
			name: name,
			students: max_students,
			duration: duration.to_s + " " + current_time_span,
			description: description,
			documentation: upload_form,
			actions: "<span class='deleteProject' id=#{id} style='cursor: pointer;'><i class='fa fa-times' aria-hidden='true' data-toggle='tooltip' data-placement='top' title='Delete project' style='color:red;'></i></span>
								<span id='showDiplomaDetails_#{id}' data-diploma-id=#{id} style='cursor: pointer;'><span class='label label-info docPopover'>View uploads</span></span>"
		}
	end

	def available_diploma?(student)
		return false if max_students == students.count
		return false if EnrollRequest.where(student: student, diploma_project: self).any?
		return false if DiplomaSelection.find_by(active: true).name == 'unique' && student.enroll_requests.any?
		true
	end

	def singular_or_taken?(student) 
		return "<i class='fa fa-star' data-toggle='tooltip' data-placement='top' title='You already requested enrollment to this project!' style='color:blue;' aria-hidden='true'></i>" if EnrollRequest.where(student: student, diploma_project: self).any?
		return "<i class='fa fa-minus-circle' data-toggle='tooltip' data-placement='top' title='You can request enroll to only one project at a time!' style='color:red;' aria-hidden='true'></i>" if DiplomaSelection.find_by(active: true).name == 'unique' && student.enroll_requests.any?
	end

	def self.retrieve_all_projects(params, student)
		response = {}
		response[:draw] = params[:draw].to_i
		response[:recordsTotal] = all.count
		response[:recordsFiltered] = all.count
		response[:data] = all.order_projects(params).offset(params[:start].to_i).limit(params[:length].to_i).map { |project| project.student_displayed_data(student) }
		response
	end

	def document_data
		{
			id: id,
			document_data: documents.map(&:data)
		}
	end

	def student_displayed_data(student)
		if available_diploma?(student)
			html = "<span class='enrollProject' data-teacher-id=#{teacher.id} data-project-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' class='fa fa-plus' title='Apply to project' style='color:green;' aria-hidden='true'></i></i></span>
					  <span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"
		else
			html = "<span>#{singular_or_taken?(student)}</span> 
						<span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"

		end
		html += "<span id='showDiplomaDetails_#{id}' data-diploma-id=#{id} style='cursor: pointer;'><i style='color: #17a589;' class='fa fa-cloud-download docPopover'></i></span>"
		{
			name: name,
			students: max_students - students.count,
			duration: duration.to_s + " " + current_time_span,
			description: description,
			teacher: teacher.name,
			actions: html
		}
	end

	def self.order_projects(params)
		projects = all
		if params[:diploma]
			params[:diploma].each do |key, value|
				if key == 'diploma_teacher' && value.present?
					values = value.split(' ')
					projects = projects.send(key, values[0], values[1])
				else
        	projects = projects.send(key, value) if value.present?
        end
      end
        ap projects
    end
		if params['order']
			order_hash = params['order']['0']
			field_to_order_by = order_hash[:column]
			direction = order_hash[:dir]
		else
			field_to_order_by = ''
		end
		case field_to_order_by
		when '1'
			projects = projects.order(max_students: direction.to_sym)
		when '2'
			projects = projects.order(duration: direction.to_sym)
		else
			projects = projects.order(created_at: :desc)
		end
		projects
	end

	def upload_form
		"<span data-project-id=#{id} class='label label-info addDocuments showModalDoc' style='cursor: pointer;' data-toggle='modal' data-target='#myUploadModal'>
			<i class='fa fa-plus' aria-hidden='true'></i> Upload files
		</span>"
	end

	def self.diploma_projects_report(temporary_local_file)
  	CSV.open(
      temporary_local_file,
      'w',
      write_headers: true,
      headers: ['Title', 'Description', 'Teacher', 'Students enrolled', 'Remaining places']
    ) do |csv|
      if any?
         all.each do |project|
		      name = project.name
		      description = project.description
		      teacher = project.teacher.name
		      enrolled = project.students.count
		      remaining = project.max_students - project.students.count
		      data_out = [ name, description, teacher, enrolled, remaining]
		      csv << data_out
		    end
      else
        csv << ['There are no diploma projects yet.']
      end
    end
    temporary_local_file
  end
end


