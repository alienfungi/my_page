class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_action :require_login

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    render 'layouts/record_not_found'
  end

  def track_activity(trackable, users = [current_user], action = params[:action])
    users.each do |user|
      user.activities.create!(action: action, trackable: trackable)
    end
  end

private

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this content."
      redirect_to login_path
    end
  end

  def validate_users(*users)
    valid = users.any? { |user| current_user? user }
    valid ||= current_user.admin
    unless valid
      flash[:error] = "Unauthorized to access that page."
      redirect_to root_path
    end
  end

  def random_code(size = 20)
    token_chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    token_length = size
    Array.new(token_length) { token_chars[rand(token_chars.length)] }.join
  end
end
