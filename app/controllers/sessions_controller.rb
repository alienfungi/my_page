class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to root_url if signed_in?
    @session_form = SessionForm.new
  end

  def create
    @session_form = SessionForm.new(session_params)
    if !@session_form.valid?
      render 'new'
    elsif User.authenticate(@session_form.email, @session_form.password).try(:confirmed)
      user = User.find_by_email(@session_form.email)
      sign_in user
      redirect_to root_url
    else
      flash.now[:error] = 'Invalid login credentials'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to login_path, flash: { notice: 'You are now logged out.' }
  end

  private

  def session_params
    params.require(:session_form).permit(:email, :password)
  end
end
