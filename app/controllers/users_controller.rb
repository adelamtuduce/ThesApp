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
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @users = User.paginate(page: params[:page])
    @document = Document.new
  end

  def show
    @user = User.find(params[:id])
    if @user.personal_information.nil?
      @personal_information = PersonalInformation.new
      @url =  personal_informations_path  
    else
      @personal_information = @user.personal_information
      @url = update_personal_information_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @role = Role.find(params["role[id]"])
    puts @role
    if @user.save
      personal_information = PersonalInformation.create
      @user.personal_information = personal_information
      @user.student = Student.create if @role.student?
      @user.teacher = Teacher.create if @role.teacher?
      @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to edit_personal_information_path(personal_information)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :role_id)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end
