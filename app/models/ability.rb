class Ability
  include CanCan::Ability

  def initialize(user, controller_namespace)
    case controller_namespace
      when 'Admin'
        can :manage, :all if user.has_role? 'admin'
      else
        case user.role.name 
        when 'Student'
          can :projects_to_enroll, Student unless user.student.diploma_project
          can :student_dasboard, Student if user.student.diploma_project
          can :manage, DiplomaProject
          can :manage, Conversation
          can :manage, Message
          can :manage, EnrollRequest
          can :manage, Event
          can :manage, Document
          can :manage, Notification
          can :show, User
          can :update, User
        when 'Profesor'
          can :manage, Teacher
          can :manage, DiplomaProject
          can :manage, Conversation
          can :manage, Message
          can :manage, EnrollRequest
          can :manage, Event
          can :manage, Document
          can :manage, Notification
          can :show, User
          can :update, User
        end
        # rules for non-admin controllers here
    end
  end
end