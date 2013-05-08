class StaticPagesController < ApplicationController

  def home
  	@comment = Comment.new
  end

  def packman
  end
  
end
