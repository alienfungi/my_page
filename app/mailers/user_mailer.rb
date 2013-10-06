class UserMailer < ActionMailer::Base
  helper :application
  default from: "user_accounts@socialnetwork.com"

  def user_confirmation_email(user)
    @user = user
    mail to: (@user.new_email || @user.email),
         subject: "Please confirm your account with the social network."
  end

  def password_recovery_email(user, new_password)
    @user = user
    @new_password = new_password
    mail to: (@user.email),
         subject: "Your password has been reset at the social network."
  end
end
