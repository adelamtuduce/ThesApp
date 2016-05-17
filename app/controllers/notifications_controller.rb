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

#

class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_notification, only: [:destroy]

  def index
  	@notifications = Notification.where(user_id: current_user.id, read: false)
  end

  def destroy
  	@notification.destroy
  	@notifications = Notification.where(user_id: current_user.id, read: false)
  end

  private

  def set_notification
  	@notification = Notification.find(params[:notification_id])
  end
end
