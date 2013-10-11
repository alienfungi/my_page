class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:destroy]
  before_action :correct_users?, only: [:destroy]

  def create
    @friendship = if params.has_key? :friend_id
      current_user.friendships.build(friend_id: params.delete(:friend_id))
    else
      current_user.friendships.build(friend_id: params.delete(:user_id))
    end
    if @friendship.save
      flash[:success] = "Friended #{@friendship.friend.username}."
      track_activity @friendship, [@friendship.user, @friendship.friend]
      redirect_to :back
    else
      flash[:error] = "Unable to add friend."
      redirect_to :back
    end
  end

  def destroy
    user = friendship.user
    friend = friendship.friend
    @inverse_friendship = Friendship.where(user: friend).first
    friend_username = friend.username
    message = "Unfriended #{ friend_username }."

    # swap variables for message purposes if necessary
    unless user == current_user
      friend_username = user.username
      @friendship, @inverse_friendship = @inverse_friendship, @friendship
    end

    # destroy friendships
    begin
      @friendship.destroy
    rescue
      message = "Rejected #{ friend_username }'s friend request."
    end
    begin
      @inverse_friendship.destroy
    rescue
      message = "Cancelled your friend request to #{ friend_username }."
    end

    flash[:success] = message
    redirect_to friendships_path
  end

  def index
    inbound_friends = current_user.inverse_friendships.map { |friendship| friendship.user }
    outbound_friends = current_user.friendships.map { |friendship| friendship.friend }

    @mutual = current_user.friendships.where(
      friend_id: inbound_friends
    ).paginate(page: params[:mutual_page])

    @requests = current_user.inverse_friendships.where.not(
      user_id: outbound_friends
    ).paginate(page: params[:requests_page])

    @pending = current_user.friendships.where.not(
      friend_id: inbound_friends
    ).paginate(page: params[:pending_page])

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

private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def correct_users?
    validate_users(@friendship.user, @friendship.friend)
  end

end
