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
		create(name: "CTI", faculty_id: 1)
		create(name: "IS", faculty_id: 1)
		create(name: "AR", faculty_id: 2)
		create(name: "IA", faculty_id: 2)
		create(name: "Random", faculty_id: 3)
	end
end
