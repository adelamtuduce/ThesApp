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
  before_action :correct_user,   only: [:edit, :update, :admin_chart_data]
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

  def settings
    @selection_modes = DiplomaSelection.all
  end

  def toggle_selection_mode
    selection = DiplomaSelection.find(params[:selection_id])
    selection.update_attributes(active: !selection.active)
    DiplomaSelection.where.not(id: selection.id).update_all(active: !selection.active)
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

  def admin_chart_data
    start_valid = true
    end_valid   = true

    begin
      from = Date.parse(Date.strptime(params[:chart_from], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_from] && params[:chart_from].length == 10
    rescue ArgumentError
      start_valid = false
    end
    begin
      to = Date.parse(Date.strptime(params[:chart_to], '%m/%d/%Y').strftime('%Y-%m-%d')).beginning_of_day if params[:chart_to] && params[:chart_to].length == 10
    rescue ArgumentError
      end_valid = false
    end

    to   = Time.zone.now.to_date if to.nil? || !end_valid
    from = to - 6.days if from.nil? || !start_valid

    from = to if from > to
    result = []
    from.to_date.step(to.to_date) do |day|
      start = day.beginning_of_day.strftime("%Y-%m-%d %T")
      end_day = day.end_of_day.strftime("%Y-%m-%d %T")
      requests = EnrollRequest.in_interval(start, end_day)
      users = User.in_interval(start, end_day)
      students = Student.in_interval(start, end_day)
      teachers = Teacher.in_interval(start, end_day)
      documents = Document.in_interval(start, end_day)
      projects = DiplomaProject.in_interval(start, end_day).map(&:get_occupied).compact
      value = {
        x: day.to_date.strftime("%Y-%m-%d"),
        requests: requests.count,
        approved_requests: requests.where(accepted: true).count,
        declined_requests: requests.where(accepted: false).count,
        pending_requests: requests.where(accepted: nil).count,
        users: users.count,
        students: students.count,
        teachers: teachers.count,
        documents: documents.count,
        projects: projects.count

      }
      result << value
    end
    render json: { result: result }
  end

  def view_data
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
