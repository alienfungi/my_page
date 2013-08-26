class StaticPagesController < ApplicationController

  def home
    @comment = Comment.new
  end

  def java
  end

  def packman
    session[:return_to] = packman_path
  end

  def cars
  end
end
