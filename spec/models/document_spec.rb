# == Schema Information
#
# Table name: documents
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  download_url      :string(255)
#  enroll_request_id :integer
#

require 'spec_helper'

describe Document do
  pending "add some examples to (or delete) #{__FILE__}"
end
