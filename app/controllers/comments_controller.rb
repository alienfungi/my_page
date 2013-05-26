class CommentsController < ApplicationController
  
  def new
    @comment = Comment.new(id: 1)
  end

  def create
    @comment = Comment.new(params[:comment])
    CommentMailer.comment_email(@comment).deliver
    redirect_to(root_url, notice: "Comment submitted.")
  end

end