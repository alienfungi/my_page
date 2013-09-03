class Score < ActiveRecord::Base
  MAX_RECORDS = 100

  validates :name, presence: true
  validates :total, presence: true

  after_save :enforce_record_limit

private

  def enforce_record_limit
    if Score.count > MAX_RECORDS
      newest_n_records = Score.find(:all, order: 'total desc', limit: MAX_RECORDS)
      Score.delete_all(['id NOT IN (?)', newest_n_records.collect(&:id)])
    end
  end
end
