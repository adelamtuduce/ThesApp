# == Schema Information
#
# Table name: import_projects
#
#  id                  :integer          not null, primary key
#  teacher_id          :integer
#  status              :string(255)      default("f")
#  created_at          :datetime
#  updated_at          :datetime
#  import_file_name    :string(255)
#  import_content_type :string(255)
#  import_file_size    :integer
#  import_updated_at   :datetime
#

class ImportProject < ActiveRecord::Base

	has_attached_file :import,
    :storage => :dropbox,
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
    :dropbox_options => {}
  validates_attachment_content_type :import, content_type: ['text/csv', 'application/vnd.ms-excel']
end
