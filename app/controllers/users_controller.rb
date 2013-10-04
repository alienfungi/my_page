class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :confirm]

  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @friendship = nil
    current_user.friendships.each do |friendship|
      @friendship = friendship if friendship.friend == @user
    end
  end

  def index
    users = if params.has_key? :search_for
      User.where("username LIKE ?", "#{Regexp.escape(params[:search_for])}%")
    else
      User
    end
    @users = users.paginate(page: params[:page])
  end

  def new
    sign_out unless current_user && current_user.admin
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      EmailConfirmationMailer.user_confirmation_email(@user).deliver
      redirect_to login_path, notice: 'Please confirm your account via the email sent to you.'
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

  def confirm
    confirmation_code = params[:confirmation_code]
    user_id = params[:user]
    @user = User.find(user_id)
    if signed_in? || @user.confirmation_code.empty?
    elsif @user.confirmation_code == confirmation_code
      @user.confirmed = true
      @user.confirmation_code = ""
      @user.save
      flash[:success] = "Account confirmed."
    else
      flash[:error] = "Account failed to confirm."
    end
    redirect_to root_url
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
