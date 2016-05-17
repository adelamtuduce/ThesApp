# == Schema Information
#
# Table name: personal_informations
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  code                :string(255)
#  age                 :integer
#  section_id          :integer
#  year                :integer
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  notifications       :boolean          default(TRUE)
#  emails              :boolean          default(TRUE)
#

class PersonalInformation < ActiveRecord::Base
	belongs_to :user
	# validates_presence_of :first_name, presence: true, length: { maximum: 50 }
	# validates_presence_of :last_name, presence: true, length: { maximum: 50 }
	# validates_presence_of :code, presence: true, length: { maximum: 10 }
	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "default_avatar.png"
  	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  	validates :first_name, presence: true, on: :update
  	validates :last_name, presence: true,  on: :update

	def student_incomplete?
		return true if first_name.blank?
		return true if last_name.blank?
		return true if age.blank?
		return true if code.blank?
		return true if section_id.blank?
		return true if year.blank?
		false
	end

	def teacher_incomplete?
		return true if first_name.blank?
		return true if last_name.blank?
		return true if section_id.blank?
		false
	end

	def name
		puts self.to_yaml
		first = first_name.blank? ? '' : first_name
		last = last_name.blank? ? '' : last_name
		first + ' ' + last
	end
end
