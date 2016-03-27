# == Schema Information
#
# Table name: personal_informations
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  code                :string(255)
#  age                 :integer
#  section_id          :integer
#  year                :integer
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require 'spec_helper'

describe PersonalInformation do
  pending "add some examples to (or delete) #{__FILE__}"
end
