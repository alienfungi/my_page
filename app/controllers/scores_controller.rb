class ScoresController < ApplicationController

  def new
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ScoresDatatable.new(view_context) }
    end
  end

  def create
    total = params[:total]
    name = params[:name]
    return_to = session.delete(:return_to)
    @score = Score.new(total: total.to_i, name: name)
    @score.save
    redirect_to return_to unless return_to.empty?
  end

end
