class ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.paginate(page: params[:page])
  end
end
