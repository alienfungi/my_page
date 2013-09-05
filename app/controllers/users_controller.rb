class UsersController < ApplicationController

  def show
  end

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to root_path, flash: { success: 'User created.' }
    else
      flash.now[:error] = 'Invalid user info.'
      render 'new'
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :new_password, :new_password_confirmation)
  end
end
