# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#

class UsersController < ApplicationController
  before_filter :authenticate_user!
  # load_and_authorize_resource
  before_action :correct_user,   only: [:edit, :update, :show]
  # before_action :admin_user,     only: :destroy

  def index
  end

  def show
    if @user.personal_information.nil?
      @personal_information = PersonalInformation.new
      @url =  personal_informations_path  
    else
      @personal_information = @user.personal_information
      @url = update_personal_information_path
    end
  end

  def edit
  end
    
  def update
    if @user.personal_information.update(personal_information_params)
      flash[:notice] = 'Personal information successfully saved.'
    else
      flash[:alert] = 'Personal information was not saved due to one or many errors.'
    end
    redirect_to user_path(@user)
  end

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :role_id)
    end

    def personal_information_params
      params.require(:personal_information).permit(
        :first_name, 
        :last_name, 
        :age,
        :year,
        :section_id,
        :code,
        :avatar,
        :user_id)
    end



    # Before filters

    def correct_user
      @user = User.find(params[:id])
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
