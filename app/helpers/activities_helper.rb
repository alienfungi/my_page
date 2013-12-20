module ActivitiesHelper
  def username(user)
    if current_user? user
      "you"
    elsif user.nil?
      "someone"
    else
      link_to(user.username, user)
    end
  end

  def possessive_username(user)
    if current_user? user
      "your"
    elsif user.nil?
      "someone's"
    else
      link_to("#{user.username}'s", user)
    end
  end

  def capital_username(user)
    if current_user? user
      "You"
    elsif user.nil?
      "Someone"
    else
      link_to("#{user.username}", user)
    end
  end

  def friend_request?(friendship)
    inverse = Friendship.where(friend: friendship.user, user: friendship.friend)
    if inverse.count == 0 || inverse.first.created_at > friendship.created_at
      true
    else
      false
    end
  end

end

