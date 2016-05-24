# == Schema Information
#
# Table name: reports
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  description      :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  csv_file_name    :string(255)
#  csv_content_type :string(255)
#  csv_file_size    :integer
#  csv_updated_at   :datetime
#

class Report < ActiveRecord::Base
	has_attached_file :csv, 
		:storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :dropbox_options => {}
  validates_attachment_content_type :csv,  content_type: ['text/csv']


  def send_to_csv(class_name, email)
    temporary_local_file = Rails.root.join("tmp/report-#{id}.csv")
   	temporary_local_file = class_name.classify.constantize.send(title, temporary_local_file)
    deliver_report(temporary_local_file, email)
  end

  def deliver_report(temporary_local_file, admin_email)
    self.csv                      = File.open(temporary_local_file)
    self.csv_content_type         = 'text/csv'
    save

    OverviewMailer.send_report(self, admin_email).deliver
  end

  def self.create_reports
  	create(title: 'students_report', description: 'Report containing all students from the beginning untill current time.')
  	create(title: 'teachers_report', description: 'Report containing all teachers from the beginning untill current time.')
  	create(title: 'users_report', description: 'Report containing all users from the beginning untill current time.')
  	create(title: 'documents_report', description: 'Report containing all documents uploaded from the beginning untill current time.')
  	create(title: 'diploma_projects_report', description: 'Report containing all diploma projects proposed from the beginning untill current time.')
  	create(title: 'enroll_requests_report', description: 'Report containing all enroll requests from the beginning untill current time.')
  end
end
