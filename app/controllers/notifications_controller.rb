#

class NotificationsController < ApplicationController
  before_filter :authenticate_user!

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