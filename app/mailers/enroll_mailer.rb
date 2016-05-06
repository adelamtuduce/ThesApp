class EnrollMailer < ActionMailer::Base
  default from: "thesapp@cs.upt.ro"

   def enroll_student(sender, recipient, diploma)
    @teacher = recipient
    @student = sender
    @diploma = diploma
    mail(to: recipient.user.email)
  end
end
