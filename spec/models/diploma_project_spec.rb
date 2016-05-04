# == Schema Information
#
# Table name: diploma_projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  students   :integer
#  duration   :integer
#  created_at :datetime
#  updated_at :datetime
#  teacher_id :integer
#

require 'spec_helper'

describe DiplomaProject do
  pending "add some examples to (or delete) #{__FILE__}"
end
