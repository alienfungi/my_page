class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:update, :destroy, :show]
  before_action :correct_users?, only: [:edit, :update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @valid = @micropost.save
    track_activity(@micropost, @micropost.user.mutual_friends.all << current_user) if @valid
    respond_to do |format|
      format.html do
        flash[:error] = "Post failed to create." unless @valid
        redirect_to :back
      end
      format.js do
      end
    end
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
    @micropost_id = @micropost.id
    @micropost.destroy
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js do
      end
    end
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
    params.require(:micropost).permit(:content)
  end
end
