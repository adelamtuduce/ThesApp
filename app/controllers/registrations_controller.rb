class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @user = User.new(user_params)
    @role = Role.find(params[:role][:id])
    @user.role_id = @role.id
    @user.save
    if @user.save
      personal_information = PersonalInformation.create(personal_information_params)
      @user.personal_information = personal_information
      Student.create(user_id: @user.id) if @role.student?
      Teacher.create(user_id: @user.id) if @role.teacher?
      @user.save
      AdminMailer.new_user_waiting_for_approval(@user).deliver
      sign_in @user
      
      redirect_to @user, success: "Welcome to the Thesis Manager"
    else
      render 'new'
    end
  end

  def update
    super
  end

  private

    def personal_information_params
      params.require(:personal_information).permit(:first_name, :last_name, :code)
    end

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :role_id)
    end
end 