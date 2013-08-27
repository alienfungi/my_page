class CommentsController < ApplicationController
  
  def new
    @comment = Comment.new(id: 1)
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.valid?
      begin
        CommentMailer.comment_email(@comment).deliver
      rescue
        redirect_to(contact_url, error: "Comment failed to transmit.")
      else
        redirect_to(contact_url, notice: "Comment submitted.")
      end
    else
      redirect_to(contact_url, alert: "Invalid comment information.")
    end
  end

end
