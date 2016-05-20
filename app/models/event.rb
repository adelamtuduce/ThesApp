# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  allDay     :string(255)
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base

  has_many :student_events
  belongs_to :teacher
end
