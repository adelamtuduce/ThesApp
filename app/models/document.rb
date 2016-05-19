# == Schema Information
#
# Table name: documents
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  created_at         :datetime
#  updated_at         :datetime
#  file_file_name     :string(255)
#  file_content_type  :string(255)
#  file_file_size     :integer
#  file_updated_at    :datetime
#  download_url       :string(255)
#  enroll_request_id  :integer
#  diploma_project_id :integer
#

class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :diploma_project
  belongs_to :enroll_request
  has_attached_file :file,
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :dropbox_options => {}
  validates_attachment_content_type :file, :content_type => ["application/pdf","application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"]

  after_create :save_download_url

  scope :in_interval, -> (start_date, end_date) { where("date(created_at) >= date('#{start_date}') AND date(created_at) <= date('#{end_date}')") }

  def save_download_url    
  end

  def data
    {
      id: id,
      document_name: file_file_name,
      download_url: download_url,
      delete_url: "<a class='fileName' data-remote='true' action='destroy' href='/documents/#{id}' data-method='delete'><span class='label label-danger'>Delete</span></a>",
      file_type: file_type
    }
  end

  def file_type
    case file_content_type
    when 'application/pdf'
      return 'pdf'
    when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      return 'excel'
    when 'application/msword'
      return 'word'
    else
      return 'text'
    end
  end
end
