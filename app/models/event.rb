# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  start_at   :datetime
#  end_at     :datetime
#  allDay     :string(255)
#  student_id :integer
#  teacher_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base

  belongs_to :student
  belongs_to :teacher

  # scope :between, lambda {|start_time, end_time| {:conditions => ["? < starts_at and starts_at < ?", Event.format_date(start_time), Event.format_date(end_time)] }}
  def self.between(start_time, end_time)
  	puts start_time
  	puts end_time
    where('start_at > ? and start_at < ?',
     Event.format_date(start_time),
     Event.format_date(end_time)
    )
  end

  def self.format_date(date_time)
  	puts date_time
  	puts Time.at(date_time.to_i)
  	puts Time.parse(date_time).utc.beginning_of_day
   	Time.parse(date_time)
  end

  def as_json(options = {})
  	puts self.start_at
  	puts self.end_at
    {
      :id => id,
      :title => title,
      :start => start_at.rfc822,
      :end => end_at.rfc822,
      :allDay => allDay,
      :student_id => student_id,
      :teacher_id => teacher_id,
      :url => Rails.application.routes.url_helpers.events_path(id),
      :color => "green"
    }
  end
end
