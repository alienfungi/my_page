class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_action :require_login

  before_action :set_header_links
  before_action :set_social_links

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render 'layouts/record_not_found'
  end

  def track_activity(trackable, action = params[:action])
    current_user.activities.create!(action: action, trackable: trackable)
  end

private

  def set_header_links
    @header_links = {
      "Home" => root_path,
      "Java" => java_path,
      "Resume" => resume_path,
      "Contact" => contact_path
    }
  end

  def set_social_links
    @social_links = {
      "My Profile" => current_user,
      "Users" => users_path,
      "Friends" => friendships_path,
      "Messages" => messages_path,
      "Logout" => logout_path
    }
  end

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this content."
      redirect_to login_path
    end
  end
end
