class SessionsController < ApplicationController

  def new
  end

  def create
    email = params[:session][:email].downcase
    if User.authenticate(email, params[:session][:password])
      user = User.find_by_email(email)
      sign_in user
      redirect_to root_url, flash: { success: 'You are now logged in.' }
    else
      flash.now[:error] = 'Invalid login credentials'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
