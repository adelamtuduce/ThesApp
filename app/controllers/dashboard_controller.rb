class DashboardController < ApplicationController

  def home
    if user_signed_in?
      if current_user.regular_user?
        if current_user.incomplete_information?
          redirect_to user_path(current_user)
        end
        case Role.find(current_user.role_id).name
        when 'Student'
          if current_user.student.diploma_project
            redirect_to student_dasboard_student_path(current_user.student)
          else
            redirect_to projects_to_enroll_student_path(current_user.student)
          end
        end
      else
        redirect_to users_path
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
