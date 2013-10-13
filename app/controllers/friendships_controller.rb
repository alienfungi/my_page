class FriendshipsController < ApplicationController

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
    @friendship = current_user.friendships.where(friend_id: params[:id])
    @inverse_friendship = current_user.inverse_friendships.where(user_id: params[:id])
    friend = User.find(params[:id])
    message = "Unfriended #{ friend.username }."

    # destroy friendships
    begin
      @friendship.first.destroy
    rescue
      message = "Rejected #{ friend.username }'s friend request."
    end
    begin
      @inverse_friendship.first.destroy
    rescue
      message = "Cancelled your friend request to #{ friend.username }."
    end

    flash[:success] = message
    redirect_to friendships_path
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
