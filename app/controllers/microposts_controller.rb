class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:update, :destroy, :show]
  before_action :correct_users?, only: [:edit, :update, :destroy]

  def create
    @micropost = Micropost.new(micropost_params)
    if @micropost.save
      track_activity(@micropost, @micropost.user.mutual_friends.all << current_user)
      flash[:success] = "Post created."
    else
      flash[:error] = "Post failed to create."
    end
    redirect_to :back
  end

  def update
    @updated_micropost = Micropost.find(params[:id])
    respond_to do |format|
      format.html do
        @updated_micropost.update(micropost_params)
        redirect_to :back
      end
      format.js do
        @valid = @updated_micropost.update(micropost_params)
        @updated_micropost = Micropost.find(params[:id]) unless @valid
        render 'update'
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to :back
  end

  def show
  end

private

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def correct_users?
    validate_users(@micropost.user)
  end

  def micropost_params
    params.require(:micropost).permit(:content, :user_id)
  end
end
