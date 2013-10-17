class FriendshipsController < ApplicationController

  def create
    @friendship = if params.has_key? :friend_id
      current_user.friendships.build(friend_id: params.delete(:friend_id))
    else
      current_user.friendships.build(friend_id: params.delete(:user_id))
    end
    @valid = @friendship.save
    track_activity @friendship, [@friendship.user, @friendship.friend] if @valid
    respond_to do |format|
      format.html do
        if @valid
          flash[:success] = "Friended #{@friendship.friend.username}."
        else
          flash[:error] = "Unable to add friend."
        end
        redirect_to :back
      end
      format.js do
        if current_user.mutual_friends.include? @friendship.friend
          inverse_friendship = current_user.inverse_friendships.where(user: @friendship.friend).first
          @new_activity = current_user.activities.where(trackable: @friendship).first
          @activity = current_user.activities.where(trackable: inverse_friendship).first
        end
      end
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by_friend_id(params[:id])
    @inverse_friendship = current_user.inverse_friendships.find_by_user_id(params[:id])
    activity = current_user.activities.where(trackable: @inverse_friendship).first unless @inverse_friendship.nil?
    @activity_id = activity.id if activity
    activity.try(:destroy)
    friend = User.find(params[:id])
    message = "Unfriended #{ friend.username }."

    # destroy friendships
    begin
      @friendship.destroy
    rescue
      message = "Rejected #{ friend.username }'s friend request."
    end
    begin
      @inverse_friendship.destroy
    rescue
      message = "Cancelled your friend request to #{ friend.username }."
    end

    respond_to do |format|
      format.html do
        flash[:success] = message
        redirect_to :back
      end
      format.js do
      end
    end
  end

  def index
    @mutual = current_user.mutual_friends.paginate(page: params[:mutual_page])
    @requests = current_user.friend_requests.paginate(page: params[:requests_page])
    @pending = current_user.pending_friends.paginate(page: params[:pending_page])
    @active_tab = params.delete(:active_tab) || session.delete(:active_tab) || 'mutual'
  end

  def friends
    session[:active_tab] = 'mutual'
    redirect_to friendships_path
  end

  def requests
    session[:active_tab] = 'requests'
    redirect_to friendships_path
  end

  def pending
    session[:active_tab] = 'pending'
    redirect_to friendships_path
  end

end
