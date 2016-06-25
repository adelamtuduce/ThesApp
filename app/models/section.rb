# == Schema Information
#
# Table name: sections
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  faculty_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Section < ActiveRecord::Base

	belongs_to :faculty
	
	def self.create_sections
		create(name: "CTI", faculty: Faculty.first)
		create(name: "IS", faculty: Faculty.first)
		create(name: "Informatica", faculty: Faculty.first)
	end
end
