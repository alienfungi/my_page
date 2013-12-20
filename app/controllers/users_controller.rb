class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :confirm, :recover, :home]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_users?, only: [:edit, :update, :destroy]

  def home
    if signed_in?
      @micropost = Micropost.new
      @microposts = current_user.all_microposts.includes(comments: [:user, :commentable]).paginate(page: params[:page])
      @activities = current_user.activities.includes(:trackable)
      @friends = current_user.mutual_friends
    else
      redirect_to login_path
    end
  end

  def poll
    respond_to do |format|
      format.html do
        redirect_to root_path
      end
      format.js do

        # load new activities or false
        @new_activities = current_user.activities.where(old: false)
        if @new_activities.count > 0
          @new_activities.load
          current_user.activities.update_all(old: true)

          # load new friends or false
          new_friend_activity = @new_activities.where(trackable_type: 'Friendship').map do |activity|
            friendship = activity.trackable
            current_user?(friendship.user) ? friendship.friend.id : friendship.user.id
          end
          friends_new = current_user.mutual_friends.where(id: new_friend_activity)
          @new_friends = friends_new.count > 0 ? friends_new.load : false
        else
          @new_activities = false
        end
      end
    end
  end

  def show
    @micropost = Micropost.new
    @friendship = nil
    current_user.friendships.each do |friendship|
      @friendship = friendship if friendship.friend_id == @user
    end
    @microposts = @user.microposts.includes(comments: [:user]).paginate(page: params[:page])
  end

  def index
    @search_form = params.has_key?(:search_form) ? SearchForm.new(search_params) : SearchForm.new
    users = if @search_form.search_for.blank?
      User
    else
      User.where(
        "lower(username) LIKE lower(?)",
        "#{Regexp.escape(@search_form.search_for)}%"
      )
    end
    respond_to do |format|
      format.html do
        @users = users.paginate(page: params[:page])
      end
      format.js do
        @users = users.paginate(page: nil)
        render 'users'
      end
    end
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
    @user_id = @user.id
    @user.destroy
    respond_to do |format|
      format.html do
        flash[:success] = "User deleted."
        redirect_to users_path
      end
      format.js do
      end
    end
  end

  def confirm
    confirmation_code = params.delete(:confirmation_code)
    user_id = params.delete(:user)
    @user = User.unscoped.find(user_id)
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
    sign_out
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(:email, :new_email, :username, :new_password, :new_password_confirmation, :headline, :about)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_users?
    validate_users(@user)
  end
end
