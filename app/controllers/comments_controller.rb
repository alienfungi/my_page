class CommentsController < ApplicationController
  
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(params[:comment])

    notification = if @comment.valid?
      begin
        CommentMailer.comment_email(@comment).deliver
        { success: "Message submitted." }
      rescue
        { error: "Message failed to submit." }
      end
    else
      { alert: "Invalid information." }
    end

    redirect_to(contact_url, flash: notification)
  end

end
