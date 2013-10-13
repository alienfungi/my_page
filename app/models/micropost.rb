class Micropost < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :content
  validates :content, length: { maximum: 250 }

  default_scope { order('created_at DESC') }
end
