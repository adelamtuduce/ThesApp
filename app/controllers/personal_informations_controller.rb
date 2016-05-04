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

class PersonalInformationsController < ApplicationController
	before_action :set_pi, except: [:create]
  skip_before_filter :verify_authenticity_token

# def new
#   @personal_information = PersonalInformation.new
# end

def create
  @personal_information = PersonalInformation.new(personal_information_params)
  @personal_information.save
end

def update
	if @personal_information.update(personal_information_params)
		flash[:notice] = 'User saved'
    redirect_to user_path(params[:id])
	else
		render 'new'
	end
end

def edit
end

private

  def personal_information_params
    params.require(:personal_information).permit(
    	:first_name, 
    	:last_name, 
    	:age,
    	:year,
    	:faculty_id,
    	:code,
      :avatar,
      :user_id)
  end

  def set_pi
  	@personal_information = User.find(params[:id]).personal_information
  end
end
