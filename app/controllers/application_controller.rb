class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_header_links

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
