# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  message    :text
#  icon       :string(255)
#  read       :boolean          default(FALSE)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
