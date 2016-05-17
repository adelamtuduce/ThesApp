class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: :destroy

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

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :role_id)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
