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

require 'spec_helper'

describe Report do
  pending "add some examples to (or delete) #{__FILE__}"
end
