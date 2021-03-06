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
#  notifications       :boolean          default(TRUE)
#  emails              :boolean          default(TRUE)
#

class PersonalInformationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
	before_action :set_pi, except: [:create, :toggle_notifications, :toggle_emails]
  skip_before_filter :verify_authenticity_token


  def create
    @personal_information = PersonalInformation.new(personal_information_params)
    @personal_information.save
  end


  def toggle_notifications
    @personal_information = PersonalInformation.find(params[:information_id])
    @personal_information.update_attributes(notifications: !@personal_information.notifications)
  end

  def toggle_emails
    @personal_information = PersonalInformation.find(params[:information_id])
    @personal_information.update_attributes(emails: !@personal_information.emails)
  end

  def edit
  end

  private


    def set_pi
    	@personal_information = User.find(params[:id]).personal_information
    end
end
