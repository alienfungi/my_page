class ScoresController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ScoresDatatable.new(view_context) }
    end
  end

  def create
    return_to = session.delete(:return_to)
    @score = Score.new(score_params)
    @score.save
    redirect_to return_to unless return_to.empty?
  end

private

  def score_params
    params.require(:score).permit(:name, :total)
  end
end
