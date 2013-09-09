module UsersHelper

  #Returns the Gravatar (http:// gravatar.com/) for the given user.
  def gravatar_for(user, options = { })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options.delete(:size) { 50 }
    options[:class] = "gravatar " + options.fetch(:class, "")
    options[:alt] ||= user.username
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, options)
  end

end
