class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:edit, :update, :destroy]
  before_action :correct_users?, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @micropost = Micropost.new(micropost_params)
    if @micropost.save
      flash[:success] = "Post created."
    else
      flash[:error] = "Post failed to create."
    end
    redirect_to current_user
  end

  def update
    if @micropost.update(micropost_params)
      redirect_to current_user
    else
      render action: 'edit'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to current_user
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
