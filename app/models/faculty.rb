# == Schema Information
#
# Table name: faculties
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Faculty < ActiveRecord::Base

	has_many :sections
	def self.create_faculties
		create(name: "Automatica si Calculatoare")
		create(name: "Mecanica")
		create(name: "Electronica si telecomunicatii")
	end
end
