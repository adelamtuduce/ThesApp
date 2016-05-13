# == Schema Information
#
# Table name: diploma_projects
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  max_students               :integer
#  duration                   :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  teacher_id                 :integer
#  description                :text
#  documentation_file_name    :string(255)
#  documentation_content_type :string(255)
#  documentation_file_size    :integer
#  documentation_updated_at   :datetime
#

require 'spec_helper'

describe DiplomaProject do
  pending "add some examples to (or delete) #{__FILE__}"
end
