class Score < ActiveRecord::Base
  attr_accessible :name, :total

  validates :name, presence: true
  validates :total, presence: true
end
