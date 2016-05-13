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

class Notification < ActiveRecord::Base
	belongs_to :user
end
