class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :confirm, :recover]

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
    @user.confirmation_code = random_code(20)
    if @user.save
      UserMailer.user_confirmation_email(@user).deliver
      redirect_to login_path, notice: 'Please confirm your account via the email sent to you.'
    else
      flash.now[:error] = 'Invalid user info.'
      render 'new'
    end
  end

  def edit
  end

  def update
    params[:user][:new_email] = nil if params[:user][:new_email] == @user.email
    if @user.update_attributes(user_params)
      flash[:success] = "User updated."
      if @user.new_email
        @user.confirmation_code = random_code(20)
        @user.save
        UserMailer.user_confirmation_email(@user).deliver
      end
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
    if @user.confirmation_code.empty?
      redirect_to root_url
    elsif @user.confirmation_code == confirmation_code
      @user.confirmation_code = ""
      @user.new_email.blank? ? new_account : new_email 
    end
  end

  def recover
    @user = User.find_by_email(params[:recover][:email].downcase)
    if @user
      new_password = random_code(10)
      @user.update_attributes(password: new_password)
      UserMailer.password_recovery_email(@user, new_password).deliver
      flash[:notice] = "An email has been sent to you with a new, temporary password."
    else
      flash[:error] = "User not found."
    end
    redirect_to root_url
  end

private

  def new_email
    @user.email = @user.new_email
    @user.new_email = nil
    if @user.save
      flash[:success] = "Email successfully updated."
    else
      flash[:error] = "Email failed to update."
    end
    sign_in @user
    redirect_to @user
  end

  def new_account
    @user.confirmed = true
    if @user.save
      flash[:success] = "You may now log in."
    else
      flash[:error] = "Email failed to confirm."
    end
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(:email, :new_email, :username, :new_password, :new_password_confirmation, :headline, :about)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) || current_user.admin
  end
end
