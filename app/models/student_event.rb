# == Schema Information
#
# Table name: student_events
#
#  id         :integer          not null, primary key
#  student_id :integer
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class StudentEvent < ActiveRecord::Base
	belongs_to :student
	belongs_to :event
end
