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

require 'spec_helper'

describe ImportProject do
  pending "add some examples to (or delete) #{__FILE__}"
end
