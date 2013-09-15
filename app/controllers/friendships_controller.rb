class FriendshipsController < ApplicationController
  def create
    @friendship = if params.has_key? :friend_id
      current_user.friendships.build(friend_id: params.delete(:friend_id))
    else
      current_user.friendships.build(friend_id: params.delete(:user_id))
    end
    if @friendship.save
      flash[:success] = "Added friend."
      redirect_to users_path
    else
      flash[:error] = "Unable to add friend."
      redirect_to users_path
    end
  end

  def destroy
    message = "Removed friendship."
    begin
      @friendship = current_user.friendships.find(params[:id])
      @friendship.destroy
    rescue
      message = "Denied Friend request."
    end
    begin
      @friendship = current_user.inverse_friendships.find(params[:id])
      @friendship.destroy
    rescue
      message = "Cancelled friend request."
    end
    flash[:success] = message
    redirect_to users_path
  end

  def index
    inbound_friends = current_user.inverse_friendships.map { |friendship| friendship.user }
    outbound_friends = current_user.friendships.map { |friendship| friendship.friend }

    @mutual = current_user.friendships.keep_if do |friendship|
      inbound_friends.include? friendship.friend
    end

    @requests = current_user.inverse_friendships.reject do |friendship|
      outbound_friends.include? friendship.user
    end

    @pending = current_user.friendships.reject do |friendship|
      inbound_friends.include? friendship.friend
    end

    @active_tab = 'mutual'
  end
end
