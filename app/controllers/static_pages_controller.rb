class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def home
  end

  def contact
    @comment = Comment.new
  end

  def resume
  end

  def java
  end

  def packman
    session[:return_to] = packman_path
  end

  def cars
  end
end
