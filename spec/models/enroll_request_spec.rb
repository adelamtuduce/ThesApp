# == Schema Information
#
# Table name: enroll_requests
#
#  id                 :integer          not null, primary key
#  student_id         :integer
#  teacher_id         :integer
#  diploma_project_id :integer
#  accepted           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  priority           :integer
#  sent               :boolean          default(FALSE)
#

require 'spec_helper'

describe EnrollRequest do
  pending "add some examples to (or delete) #{__FILE__}"
end
