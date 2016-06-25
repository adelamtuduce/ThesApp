class DashboardController < ApplicationController
  before_filter :authenticate_user!, except: [:show_all_projects]

  def home
  end

  def show_all_projects
    @projects = DiplomaProject.all
  end

  def root
    if current_user.regular_user?
        if current_user.incomplete_information?
          ap "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
          root_p = user_path(current_user)
        else
          case Role.find(current_user.role_id).name
          when 'Student'
            if current_user.student.diploma_project
              root_p = student_dasboard_student_path(current_user.student)
            else
              root_p = projects_to_enroll_student_path(current_user.student)
            end
          when 'Profesor'
            root_p = projects_teacher_path(current_user.teacher)
          end
        end
    else
      root_p = admin_show_all_users_path
    end
    redirect_to root_p
  end

  def help
  end

  def about
  end

  def contact
  end
end
