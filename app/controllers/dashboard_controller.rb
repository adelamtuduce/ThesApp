class DashboardController < ApplicationController

  def home
    if user_signed_in?
      if current_user.incomplete_information?
        redirect_to user_path(current_user)
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
