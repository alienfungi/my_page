class ScoresDatatable
  delegate :params, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Score.count,
      iTotalDisplayRecords: scores.total_entries,
      aaData: data
    }
  end

private

  def data
    scores.map do |score|
      [
        score.total,
        CGI::escapeHTML(score.name)
      ]
    end
  end

  def scores
    @scores ||= fetch_scores
  end

  def fetch_scores
    scores = Score.order("#{sort_column} #{sort_direction}")
    scores = scores.page(page).per_page(per_page)
    if params[:sSearch].present?
      scores = scores.where("name like :search", search: "%#{params[:sSearch]}%")
    end
    scores
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[total name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
