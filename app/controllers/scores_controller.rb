class ScoresController < ApplicationController

  def new
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ScoresDatatable.new(view_context) }
    end
  end

end
