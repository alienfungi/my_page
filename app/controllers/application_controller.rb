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

end
