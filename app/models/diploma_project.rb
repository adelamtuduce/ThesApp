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

	def student_displayed_data(student)
		if available_diploma?(student)
			html = "<span class='enrollProject' data-teacher-id=#{teacher.id} data-project-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' class='fa fa-plus' title='Apply to project' style='color:green;' aria-hidden='true'></i></i></span>
					  <span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"
		else
			html = "<span>#{singular_or_taken?(student)}</span> 
						<span class='viewDetails' data-details-id=#{id} style='cursor: pointer;'><i data-toggle='tooltip' data-placement='top' title='More Details' class='fa fa-cogs' aria-hidden='true'></i></span>"

		end
		{
			id: id,
			name: name,
			students: max_students - students.count,
			duration: duration,
			description: description,
			teacher: teacher.name,
			actions: html
		}
	end

	def self.order_projects(params)
		order_hash = params['order']['0']
		field_to_order_by = order_hash[:column]
		direction = order_hash[:dir]
		case field_to_order_by
		when '1'
			projects = all.order(max_students: direction.to_sym)
		when '2'
			projects = all.order(duration: direction.to_sym)
		else
			projects = all.order(created_at: :desc)
		end
		projects
	end
end


