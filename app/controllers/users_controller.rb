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
    
  def update
    ap @user.personal_information.valid?
    ap @user.personal_information.errors
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
