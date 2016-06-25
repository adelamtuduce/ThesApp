class AdminMailer < ActionMailer::Base
	default from: "thesapp@cs.upt.ro"
	def new_user_waiting_for_approval(user)
		@user = user
		mail(to: "admin@example.com")
	end

	def send_approval_confirmation(user)
		@user = user
		mail(to: @user.email)
	end
end