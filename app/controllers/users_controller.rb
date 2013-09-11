class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  before_action :correct_user, only: [:edit, :update]
  before_action :set_sidebar_links

  def set_sidebar_links
    @sidebar_links = {
      "My Profile" => @current_user,
      "Users" => users_path,
      "Messages" => messages_path,
      "Logout" => logout_path
    }
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    users = if params.has_key? :search_for
      User.where("username LIKE ?", "#{Regexp.escape(params[:search_for])}%")
    else
      User
    end
    @users = users.paginate(page: params[:page], per_page: 10)
  end

  def new
    sign_out unless current_user && current_user.admin
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user unless current_user && current_user.admin
      redirect_to @user, flash: { success: 'User created.' }
    else
      flash.now[:error] = 'Invalid user info.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "User updated."
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "Invalid information."
      render 'edit'
    end
  end

  def destroy
    begin
      User.destroy(params[:id])
      flash[:success] = "User deleted."
    rescue
      flash[:error] = "Record not found."
    end
    redirect_to users_path
  end

private

  def user_params
    params.require(:user).permit(:email, :username, :new_password, :new_password_confirmation, :headline, :about)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) || current_user.admin
  end
end
