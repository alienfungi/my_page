module ApplicationHelper
  BASE_TITLE = "The Network"

  def full_title(page_title = '')
    if page_title.empty?
      BASE_TITLE
    else
      "#{BASE_TITLE} | #{page_title}"
    end
  end

  # sets heading to :heading, :title, or "The Network" in that priority
  def heading(page_heading = '', page_title = '')
    default_heading = BASE_TITLE
    if page_heading.empty? && page_title.empty?
      default_heading
    elsif page_heading.empty?
      page_title
    else
      page_heading
    end
  end

  def flash_class(type)
    "alert alert-" + case type
      when :success then "success"
      when :notice then "info"
      when :alert then "warning"
      when :error then "danger"
      else "invalid-type"
    end
  end

  def host
    if Rails.env.production?
      "http://zanes-social-network.herokuapp.com/"
    else
      "http://localhost:3000/"
    end
  end

  def header_links
    # check for new friend requests
    inbound_friends = current_user.inverse_friendships.map { |friendship| friendship.user }
    mutual_friends = current_user.friendships.where(friend_id: inbound_friends)
    new_friend_count = inbound_friends.size - mutual_friends.size

    # check for new messages
    new_message_count = current_user.received_messages.where(read: false).count

    # create links
    {
      "My Profile" => current_user,
      "Activity" => activities_path,
      "Users" => users_path,
      "Friends#{create_badge(new_friend_count)}" => friendships_path,
      "Messages#{create_badge(new_message_count)}" => messages_path
    }
  end

  def format_time(time)
    time.in_time_zone(
      cookies["browser.timezone"] || Time.zone
    ).strftime("%b %d, %Y %I:%M %P").gsub(/0(\d:\d\d)/) { $1 }
  end

private

  def create_badge(num)
    if num > 0
      " <span class='badge'>#{num}</span>"
    else
      ""
    end
  end
end
