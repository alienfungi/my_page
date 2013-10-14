class CommentsController < ApplicationController

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @valid = @comment.save
    track_activity(@comment, [@commentable.user, @comment.user])
    respond_to do |format|
      format.html do
        if @valid
          flash[:success] = "Successfully created comment."
          redirect_to id: nil
        else
          render action: 'new'
        end
      end
      format.js do
        render 'create'
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    validate_users(@comment.user, @comment.commentable.user)
    unless current_user? @comment.commentable.user
      @comment.activities.destroy_all
    end
    @comment_id = @comment.id
    @comment.destroy
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js do
      end
    end
  end

private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def comment_params
    params.require(:comment).permit(:content, :commentable, :user_id)
  end
end

