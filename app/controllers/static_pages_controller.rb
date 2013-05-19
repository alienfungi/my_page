class StaticPagesController < ApplicationController

  def home
  	@comment = Comment.new
  end

  def java
  end

  def packman
  end

  def cars
  end
end
