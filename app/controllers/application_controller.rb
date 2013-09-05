class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_action :require_login

  before_action :set_header_links

  #filter_parameter_logging :password

private

  def set_header_links
    @header_links = {
      "Home" => root_path,
      "Java" => java_path,
      "Resume" => resume_path,
      "Contact" => contact_path
    }
  end

  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this content."
      redirect_to login_path
    end
  end
end
