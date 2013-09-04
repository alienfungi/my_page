class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :set_header_links

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
end
