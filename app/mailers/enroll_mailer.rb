class EnrollMailer < ActionMailer::Base
  default from: "thesapp@cs.upt.ro"

  def enroll_student(request)
    @teacher = request.teacher
    return unless @teacher.user.personal_information.emails
    @student = request.student
    @diploma = request.diploma_project
    request.update_attributes(sent: true)
    Notification.create(user_id: @teacher.user.id, 
                        title: "New Enrollment Request - #{@student.name}", 
                        message: "#{@student.name} has sent you an enroll request for #{@diploma.name}.")
    mail(to: @teacher.user.email)
  end

  def accept_enroll(request)
    @student = request.student
    return unless @student.user.personal_information.emails
    @teacher = request.teacher
    @diploma = request.diploma_project
    Notification.create(user_id: @student.user.id, 
                        title: "Accepted Enrollment - #{@teacher.name}", 
                        message: "Your enroll request for #{@diploma.name} has been accepted.")
    mail(to: @student.user.email)
  end

  def decline_enroll(request)
    @student = request.student
    return unless @student.user.personal_information.emails
    @teacher = request.teacher
    @diploma = request.diploma_project
    Notification.create(user_id: @student.user.id, 
                        title: "Declined Enrollment - #{@teacher.name}", 
                        message: "Your enroll request for #{@diploma.name} has been declined.")
    mail(to: @student.user.email)
  end

  def decline_other_enrolls(student)
    @student = student
    return unless @student.user.personal_information.emails
    mail(to: @student.user.email)
  end

  def cancel_sent_requests(request)
    @teacher = request.teacher
    return unless @teacher.user.personal_information.emails
    @student = request.student
    @diploma = request.diploma_project
    mail(to: @teacher.user.email)
  end
end
