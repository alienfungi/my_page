class EmailConfirmationMailer < ActionMailer::Base
  helper :application
  default from: "EmailConfirmationMailer@socialnetwork.com"

  def user_confirmation_email(user)
    @user = user
    mail to: @user.email,
         subject: "Please confirm your account with the social network."
  end
end
