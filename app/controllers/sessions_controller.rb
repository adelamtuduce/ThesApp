class SessionsController < Devise::SessionsController

  def new
  end

  def create
    if user_signed_in? && params[:remember_email] == '1'
      cookies[:remembered_email] = {
        value: params[:user][:email],
        expires: 1.month.from_now
      }
    else
      cookies.delete :remembered_email
    end
    puts "JJJJJJJJJJJJJJJJJJJJJJJJJJJ"
    puts params
    puts "JJJJJJJJJJJJJJJJJJJJJJJJJJJ"
    super
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end