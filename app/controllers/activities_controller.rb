class ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.includes(:trackable).paginate(page: params[:page])
  end
end
